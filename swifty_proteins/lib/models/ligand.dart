import 'atom.dart';
import 'bond.dart';

// This class represnets 1 fully parsed ligand protein .cif file, ready to be handed to the 3D builder
class Ligand {
  final String code; // the actual code of the protein that we parsed from the .cif file
  final List<Atom> atoms; // lists the atoms that the protein needs to draw/have
  final List<Bond> bonds; // lists the bonds that the protein needs to draw/have

// constructor :
  const Ligand({
    required this.code,
    required this.atoms,
    required this.bonds,
  });
}
