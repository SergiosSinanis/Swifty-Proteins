
// This class represents 1 atom inside a ligand protein (the fields of the class reflect the .cif file structure)

class Atom {
  final String id; // the id of the atom (used for drawing)
  final String element; // for cpk coloring
  final double x;
  final double y;
  final double z;

// constructor :
  const Atom({
    required this.id,
    required this.element,
    required this.x,
    required this.y,
    required this.z,
  });
}
