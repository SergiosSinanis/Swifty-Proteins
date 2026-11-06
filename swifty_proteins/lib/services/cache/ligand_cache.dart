import 'dart:io';
import 'package:path_provider/path_provider.dart';

// This service reads and writes the raw .cif text to the local disk so that previously viewed ligand can be reopened with no internet connection (cache)

class LigandCache {
  // this method creates a reference to the file's location (it doesn't create a file)
  Future<File> _fileFor(String ligandCode) async {
    final dir = await getApplicationDocumentsDirectory(); //we call this path_provider function that gives us the place/dir that the app can write on the phone local disk
    return File('${dir.path}/$ligandCode.cif'); // we add the filename in the filename pattern reference and return it
  }

// this method reads a cahed ligand file from the phone disk
  Future<String?> read(String ligandCode) async {
    final file = await _fileFor(ligandCode); // we find the file that contains our protein code
    if (!await file.exists()) { // protect if the file doesn't exist
      return null;
    }
    return file.readAsString(); // reads the contents of the local file and returns the raw CIF text from inside it
  }

// this saves a new ligand file on disk
  Future<void> write(String ligandCode, String rawCifText) async {
    final file = await _fileFor(ligandCode); // to find where our new protein should be saved
    await file.writeAsString(rawCifText); // write on this new file the raw cif text
  }
}
