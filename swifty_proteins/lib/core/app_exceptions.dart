
// Useful custom exceptions used acroos the app to catch specific known bugs instead of generic error messages
// The actual error messages live in the "LigandDetailState"

// NoConnectionException = "No internet connection. Please check your network."
class NoConnectionException implements Exception {
  const NoConnectionException();
}

// LigandNotFoundException = "Ligand not found (404). This ligand may not exist in the database."
class LigandNotFoundException implements Exception {
  final String ligandCode;
  const LigandNotFoundException(this.ligandCode);
}

// RequestTimeoutException = "Request timeout. Please try again."
class RequestTimeoutException implements Exception {
  const RequestTimeoutException();
}

// ParsingFailedException = "Failed to parse ligand data. The file may be corrupted."
class ParsingFailedException implements Exception {
  final String reason;
  const ParsingFailedException(this.reason);
}
