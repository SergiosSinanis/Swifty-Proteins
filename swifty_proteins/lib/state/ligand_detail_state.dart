import 'package:flutter/foundation.dart';
import '../models/ligand.dart';
import '../services/ligand_repository.dart';
import '../core/app_exceptions.dart';

// This state holds whether the currently opened ligand protein is loading, loaded, or failed + the specific error message to show
enum LigandLoadStatus { idle, loading, success, error }

class LigandDetailState extends ChangeNotifier {
  final LigandRepository _repository = LigandRepository(); // we create a ligand repository instance so that we can call the "getligand()" = the screen should not call things directly

  LigandLoadStatus status = LigandLoadStatus.idle;
  Ligand? ligand;
  String? errorMessage;

  Future<void> load(String ligandCode) async {
    status = LigandLoadStatus.loading;
    errorMessage = null;
    notifyListeners(); // tells to update the screen (ligand is now loading)

    try {
      ligand = await _repository.getLigand(ligandCode); // we try to get the ligand data (from cache or from the rscb.org)
      status = LigandLoadStatus.success;
    } on NoConnectionException {
      errorMessage = 'No internet connection. Please check your network.';
      status = LigandLoadStatus.error;
    } on LigandNotFoundException {
      errorMessage = 'Ligand not found (404). This ligand may not exist in the database.';
      status = LigandLoadStatus.error;
    } on RequestTimeoutException {
      errorMessage = 'Request timeout. Please try again.';
      status = LigandLoadStatus.error;
    } on ParsingFailedException {
      errorMessage = 'Failed to parse ligand data. The file may be corrupted.';
      status = LigandLoadStatus.error;
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.'; // any other error : without this, the screen would stay on "loading" forever
      status = LigandLoadStatus.error;
    }

    notifyListeners(); // tells to update the screen (ligand has loaded successfully)
  }
}
