
// This class represents 1 bond between 2 atoms :
class Bond {
  final String atomId1; // the name of the first atom attched to the bond
  final String atomId2; // the name of the second atom attched to the bond

// constructor :
  const Bond({
    required this.atomId1,
    required this.atomId2,
  });
}
