import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_scene/scene.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/atom.dart';
import '../../state/ligand_detail_state.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/navy_background.dart';
import 'atom_info_overlay.dart';
import 'molecule_scene_builder.dart';

// The ligand is already loaded when we arrive here : the list screen only navigates once loading succeeded

class ProteinViewScreen extends StatefulWidget {
  final String ligandCode;

  const ProteinViewScreen({super.key, required this.ligandCode});

  @override
  State<ProteinViewScreen> createState() => _ProteinViewScreenState();
}

class _ProteinViewScreenState extends State<ProteinViewScreen> {
  final GlobalKey _captureKey = GlobalKey();
  final GlobalKey _shareButtonKey = GlobalKey();
  MoleculeScene? _molecule;
  Atom? _selectedAtom;
  Size _sceneViewSize = Size.zero; // the size of the 3D area on screen, needed to frame the molecule and to turn a tap into a ray
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _prepareMolecule();
  }

  Future<void> _prepareMolecule() async {
    final ligand = context.read<LigandDetailState>().ligand;
    // the list screen only opens this screen once the ligand is loaded, so this should never happen
    if (ligand == null)
		return;

    await Scene.initializeStaticResources(); // flutter_scene must load its shaders once before any 3D object is created
    if (!mounted)
		return;
    setState(() {
      _molecule = MoleculeSceneBuilder().createScene(ligand);
    });
  }

  @override
  void dispose() {
    final molecule = _molecule;
    if (molecule != null) {
      molecule.scene.dispose();
    }
    super.dispose();
  }

  void _onTap(TapUpDetails details) {
    final molecule = _molecule;
    if (molecule == null)
		return; // the 3D area is only shown once the molecule exists, so this should never happen
    final camera = molecule.scene.camera;
    if (camera == null)
		return;

    final ray = camera.screenPointToRay(details.localPosition, _sceneViewSize); // the line going from the finger into the scene
    final tappedSphere = molecule.scene.raycast(
      ray,
      where: (node) => molecule.atomsBySphereNode.containsKey(node), // only the atom spheres, not the bonds
    );

    setState(() {
      if (tappedSphere == null) {
        _selectedAtom = null; // tapped outside any atom : the pop-up disappears
      } else {
        _selectedAtom = molecule.atomsBySphereNode[tappedSphere.node];
      }
    });
  }

  Future<void> _share() async {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context); // read before any await : the screen may be closed afterwards
    setState(() {
      _isSharing = true;
      _selectedAtom = null;
    });
    await WidgetsBinding.instance.endOfFrame; // so the screenshot does not contain the removed pop-up

    try {
      // the RepaintBoundary around the 3D area (see _makeSceneArea) is what can be turned into an image
      final sceneArea = _captureKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final screenshot = await sceneArea.toImage(pixelRatio: pixelRatio);
      final pngBytes = await screenshot.toByteData(format: ui.ImageByteFormat.png);
      screenshot.dispose(); // frees the image memory, we only keep the PNG bytes
      if (pngBytes == null) {
        throw Exception('The screenshot could not be converted to PNG'); // goes to the catch below
      }

      final temporaryFolder = await getTemporaryDirectory();
      final screenshotPath = '${temporaryFolder.path}/${widget.ligandCode}.png';
      await File(screenshotPath).writeAsBytes(pngBytes.buffer.asUint8List()); // the share sheet needs a real file

      if (!mounted)
	  	return;
      // on iPad the share sheet is a bubble that must point at the share button : we give it the button's position and size
      final shareButtonBox = _shareButtonKey.currentContext!.findRenderObject() as RenderBox;
      final shareButtonPosition = shareButtonBox.localToGlobal(Offset.zero);
      await SharePlus.instance.share(ShareParams(
        files: [XFile(screenshotPath, mimeType: 'image/png')],
        sharePositionOrigin: Rect.fromLTWH(shareButtonPosition.dx, shareButtonPosition.dy, shareButtonBox.size.width, shareButtonBox.size.height),
      ));
    } catch (_) {
      if (mounted) {
        ErrorDialog.show(context, title: 'Share failed', message: 'Could not share this molecule. Please try again.');
      }
    }

    if (mounted) {
      setState(() {
        _isSharing = false;
      });
    }
  }

  Widget _makeSceneArea(MoleculeScene molecule) {
    return LayoutBuilder( // a widget that tells its child how much space it has (constraints)
      builder: (context, constraints) {
        // first display or rotation of the phone : frame the whole molecule again for the new size
        if (constraints.biggest != _sceneViewSize) {
          _sceneViewSize = constraints.biggest;
          molecule.cameraController.frame(
            molecule.moleculeBox,
            margin: MoleculeSceneBuilder.cameraDistanceInDiagonals(_sceneViewSize.aspectRatio),
          );
        }

        return CameraControls(
          controller: molecule.cameraController,
          child: GestureDetector(
            onTapUp: _onTap,
            child: RepaintBoundary(
              key: _captureKey,
              // the gradient sits inside the RepaintBoundary on purpose : the 3D scene itself is transparent,
              // so this is what the shared screenshot gets as its background
              child: NavyBackground(
                child: Semantics(
                  label: '3D ball-and-stick model of ligand ${widget.ligandCode}',
                  child: SceneView(molecule.scene),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _makeScreenContent(MoleculeScene molecule) {
    final selectedAtom = _selectedAtom;
    final layers = <Widget>[
      Positioned.fill(child: _makeSceneArea(molecule)),
    ];

    if (selectedAtom != null) {
      layers.add(Positioned(
        top: 16,
        left: 0,
        right: 0,
        child: Center(
          child: AtomInfoOverlay(
            atom: selectedAtom,
            onDismiss: () {
              setState(() {
                _selectedAtom = null;
              });
            },
          ),
        ),
      ));
    }

    return Stack(children: layers);
  }

  @override
  Widget build(BuildContext context) {
    final molecule = _molecule;

    Widget screenContent;
    VoidCallback? onSharePressed;
    if (molecule == null) {
      screenContent = const LoadingView();
      onSharePressed = null;
    } else {
      screenContent = _makeScreenContent(molecule);
      if (_isSharing) {
        onSharePressed = null;
      } else {
        onSharePressed = _share;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ligandCode),
        actions: [
          IconButton(
            key: _shareButtonKey,
            onPressed: onSharePressed,
            tooltip: 'Share',
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
      // the loading spinner gets the gradient too ; the transparent app bar shows the navy scaffold color, which is the gradient's top color
      body: NavyBackground(child: screenContent),
    );
  }
}
