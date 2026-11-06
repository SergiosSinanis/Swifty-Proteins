import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/app_exceptions.dart';
import '../../core/constants.dart';

// This file represents the app's http client that talks with the site "files.rcsb.org" and fetches raw text for a ligand protein code

class RcsbClient {
  Future<String> fetchLigandCif(String ligandCode) async {
    final uri = Uri.parse('${AppConstants.rcsbBaseUrl}/${ligandCode}.cif');

    http.Response response;
    try {
      response = await http.get(uri).timeout(AppConstants.networkTimeout);
    } on TimeoutException {
      throw const RequestTimeoutException();
    } on SocketException {
      throw const NoConnectionException();
    } catch (_) {
      throw const NoConnectionException();
    }

    if (response.statusCode == 200) {
      return response.body;
    }

  // catch a 404 Not found error
    if (response.statusCode == 404) {
      throw LigandNotFoundException(ligandCode);
    }

  // catch any other error besides 404 (ex: 500) is not a "not found"
    throw HttpException('RCSB answered ${response.statusCode}');
  }
}
