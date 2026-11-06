import 'package:flutter/foundation.dart';
import '../services/ligand_repository.dart';

// This state holds the full ligand protein code list + whatever the user has typed into the search bar, and exposes the filtered list that the screen should actually render

class LigandListState extends ChangeNotifier {
  final LigandRepository _repository = LigandRepository(); // we create a ligand repository instance so that we can call the "loadLigandCodes()" = the screen should not call things directly

  List<String> _allCodes = []; // create the array to store the protein codes
  String _query = ''; // a string to store the user input
  bool isLoading = false;

// this getter searches for the proteins that match the user input
  List<String> get filteredCodes {
    if (_query.isEmpty)
      return _allCodes;
    final lower = _query.toLowerCase(); // normalize the user input in lowercase
    return _allCodes.where((c) => c.toLowerCase().contains(lower)).toList(); // return a list of strings with all the protein codes that contain the user typed text ignoring the upper/lower case
  }

  Future<void> loadCodes() async {
    _query = ''; // the list screen is new so its search bar is empty : the previous search must not survive a logout
    isLoading = true;
    notifyListeners(); // page is loading = update the screen 

    _allCodes = await _repository.loadLigandCodes(); // reads the assets ligand file and returns a list with all the proteins

    isLoading = false;
    notifyListeners(); // page loaded = update the screen 
  }

// we save what the user typed (value) and re-render the page with it in the search bar string (query)
  void updateQuery(String value) {
    _query = value;
    notifyListeners();
  }
}
