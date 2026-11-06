import 'dart:math' as math;
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import '../../core/theme/cpk_colors.dart';
import '../../models/atom.dart';
import '../../models/ligand.dart';

// This turns a parsed Ligand protein into an actual "flutter_scene" 3D scene :
// 1 colored sphere per atom, 1 thin cylinder per bond, 1 orbit camera around the molecule, and 2 lights so the structure does not look flat

class MoleculeScene {
  final Scene scene;
  final OrbitCameraController cameraController;
  final Map<Node, Atom> atomsBySphereNode; // to know which atom a tapped sphere represents
  final vm.Aabb3 moleculeBox; // the box containing the whole molecule

  const MoleculeScene({
    required this.scene,
    required this.cameraController,
    required this.atomsBySphereNode,
    required this.moleculeBox,
  });
}

class MoleculeSceneBuilder {
  static const double _defaultAtomRadius = 0.35; // every element except hydrogen
  static const double _hydrogenRadius = 0.2;
  static const double _bondRadius = 0.1;
  // how far the user can zoom out, in molecule diagonals : relative to the molecule, so a single ion and a big ligand stop at the same on-screen size
  // it must stay above the starting distance (cameraDistanceInDiagonals : about 1.2 in landscape, 2.5 in portrait), or the first view would be cut short
  static const double _maxZoomOutInDiagonals = 8;

  MoleculeScene createScene(Ligand ligand) {
    final scene = Scene();

    // 1 shared shape + 1 shared material per color = much less GPU memory than 1 per atom
    final sharedSphereShape = SphereGeometry(radius: 1, segments: 32, rings: 20);
    final sharedBondShape = CylinderGeometry(bottomRadius: 1, topRadius: 1, height: 1, radialSegments: 12);
    final sharedMaterialsByElement = <String, PhysicallyBasedMaterial>{}; // 1 material per element, shared by all the atoms of this element
    final sharedBondMaterial = _materialWithColor(0.5, 0.5, 0.5); // grey, shared by all the bonds

    final atomsBySphereNode = <Node, Atom>{}; // when the user taps a sphere, tells which atom it is (to show its element)
    final atomPositionsByName = <String, vm.Vector3>{}; // a bond only knows the names of its 2 atoms ('PG', 'O1G') : this gives where they are, to place the stick

    for (final atom in ligand.atoms) {
      final atomPosition = vm.Vector3(atom.x, atom.y, atom.z);

      double sphereRadius = _defaultAtomRadius;
      if (atom.element == 'H') {
        sphereRadius = _hydrogenRadius;
      }

      PhysicallyBasedMaterial atomMaterial;
      final existingMaterial = sharedMaterialsByElement[atom.element]; // the material, or null if not created yet
      if (existingMaterial != null) {
        atomMaterial = existingMaterial; // already created for this element : reuse it
      } else {
        final cpkColor = CpkColors.forElement(atom.element);
        atomMaterial = _materialWithColor(_toLinear(cpkColor.r), _toLinear(cpkColor.g), _toLinear(cpkColor.b));
        sharedMaterialsByElement[atom.element] = atomMaterial; // first atom of this element : create it and keep it for the next ones
      }

      final sphereNode = Node(mesh: Mesh(sharedSphereShape, atomMaterial));
      sphereNode.position = atomPosition;
      sphereNode.scale = vm.Vector3(sphereRadius, sphereRadius, sphereRadius);
      scene.add(sphereNode);

      atomsBySphereNode[sphereNode] = atom;
      atomPositionsByName[atom.id] = atomPosition;
    }

    final cylinderShapeAxis = vm.Vector3(0, 1, 0); // flutter_scene always creates a cylinder standing straight up (along y)

    for (final bond in ligand.bonds) {
      final firstAtomPosition = atomPositionsByName[bond.atomId1]; // where the 1st atom of the bond is, or null if no atom has this name
      final secondAtomPosition = atomPositionsByName[bond.atomId2];

      // a bond naming an atom missing from the file is skipped (never happens in ligands.txt, but a downloaded file could be wrong)
      final areBothAtomsKnown = firstAtomPosition != null && secondAtomPosition != null;
      if (areBothAtomsKnown) {
        final bondDirection = secondAtomPosition - firstAtomPosition; // the arrow going from the 1st atom to the 2nd
        final bondNode = Node(mesh: Mesh(sharedBondShape, sharedBondMaterial));
        bondNode.position = (firstAtomPosition + secondAtomPosition) * 0.5; // the middle of the 2 atoms, because the cylinder shape is centered on its origin
        bondNode.rotation = vm.Quaternion.fromTwoVectors(cylinderShapeAxis, bondDirection.normalized()); // turns the cylinder (vertical at first) to point from one atom to the other
        bondNode.scale = vm.Vector3(_bondRadius, bondDirection.length, _bondRadius); // thin (x and z), and as long as the distance between the 2 atoms (y)
        scene.add(bondNode);
      }
    }

    final moleculeBox = _boxContaining(atomPositionsByName.values.toList());
    final moleculeDiagonal = (moleculeBox.max - moleculeBox.min).length; // the distance between the 2 opposite corners of the box

    final cameraController = OrbitCameraController(
      target: moleculeBox.center, // the point the camera turns around
      distance: moleculeDiagonal * 3, // starting distance, adjusted to the real screen size as soon as it is displayed
      minDistance: 1, // the closest the user can zoom in
      maxDistance: moleculeDiagonal * _maxZoomOutInDiagonals, // the farthest the user can zoom out : pinch and mouse wheel both stop here
      dollySpeed: 1, // "dolly" = moving the camera forward/backward : with 1, pinching 2x makes the molecule exactly 2x bigger
    );
    final cameraNode = Node();
    cameraNode.addComponent(CameraComponent()); // makes this node the eye of the scene
    cameraNode.addComponent(cameraController); // makes this eye move with the user's gestures
    scene.add(cameraNode);

    _addLight(scene, vm.Vector3(-0.5, -1, 0.7), 1.5); // main light
    _addLight(scene, vm.Vector3(0.8, 0.4, 0.6), 0.4); // fill light from the opposite side

    return MoleculeScene(
      scene: scene,
      cameraController: cameraController,
      atomsBySphereNode: atomsBySphereNode,
      moleculeBox: moleculeBox,
    );
  }

  // the smallest box containing every atom, enlarged by 1 atom radius so the spheres are inside too
  vm.Aabb3 _boxContaining(List<vm.Vector3> atomPositions) {
    // we start from the 1st atom (the parser guarantees at least 1 atom), then widen the box with every other atom
    double minX = atomPositions[0].x;
    double minY = atomPositions[0].y;
    double minZ = atomPositions[0].z;
    double maxX = atomPositions[0].x;
    double maxY = atomPositions[0].y;
    double maxZ = atomPositions[0].z;

    for (final atomPosition in atomPositions) {
      minX = math.min(minX, atomPosition.x);
      minY = math.min(minY, atomPosition.y);
      minZ = math.min(minZ, atomPosition.z);
      maxX = math.max(maxX, atomPosition.x);
      maxY = math.max(maxY, atomPosition.y);
      maxZ = math.max(maxZ, atomPosition.z);
    }

    final lowestCorner = vm.Vector3(minX - _defaultAtomRadius, minY - _defaultAtomRadius, minZ - _defaultAtomRadius);
    final highestCorner = vm.Vector3(maxX + _defaultAtomRadius, maxY + _defaultAtomRadius, maxZ + _defaultAtomRadius);
    return vm.Aabb3.minMax(lowestCorner, highestCorner);
  }

  // our CPK hex codes are sRGB (brightness corrected for screens), but the 3D lighting computes in linear light
  double _toLinear(double srgbChannel) {
    return math.pow(srgbChannel, 2.2).toDouble();
  }

  // every sphere and bond has the same look (plastic, slightly shiny) : only the color changes
  PhysicallyBasedMaterial _materialWithColor(double red, double green, double blue) {
    final material = PhysicallyBasedMaterial();
    material.baseColorFactor = vm.Vector4(red, green, blue, 1); // the color ; the last 1 = fully opaque
    material.metallicFactor = 0; // 0 = not metal (plastic look)
    material.roughnessFactor = 0.45; // 0 = mirror, 1 = fully matte : 0.45 keeps a soft highlight so the spheres look round
    return material;
  }

  // a "directional" light has no position, only a direction : it lights any molecule the same way, whatever its size or place
  void _addLight(Scene scene, vm.Vector3 lightDirection, double lightIntensity) {
    final light = DirectionalLight(intensity: lightIntensity);
    final lightNode = Node();
    lightNode.addComponent(DirectionalLightComponent.aimed(light, lightDirection.normalized()));
    scene.add(lightNode);
  }

  // how far the camera must be, in multiples of the molecule's diagonal, to see the whole molecule on a view of this width/height ratio
  // (a phone in portrait is narrow : the molecule must fit in the width, so the camera goes further back)
  static double cameraDistanceInDiagonals(double viewAspectRatio) {
    const verticalFieldOfView = 45 * math.pi / 180; // the camera sees 45° from top to bottom (flutter_scene's default)
    final narrowestRatio = math.min(1.0, viewAspectRatio); // portrait : the width is the narrowest side
    final halfVisibleSize = math.tan(verticalFieldOfView / 2) * narrowestRatio; // half of what the camera sees, at a distance of 1
    return 1.0 / (2 * halfVisibleSize);
  }
}
