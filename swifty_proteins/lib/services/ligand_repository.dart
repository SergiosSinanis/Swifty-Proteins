import 'dart:isolate';
import '../models/ligand.dart';
import 'network/rcsb_client.dart';
import 'parsing/cif_parser.dart';
import 'cache/ligand_cache.dart';
import '../core/constants.dart';
import 'package:flutter/services.dart' show rootBundle;

// This service is the single central place that the app talks to for fetching the ligand protein data
// the Screens should never call directly the 3 services : RcsbClient, CifParser, LigandCache, but only this repository that calls them in its place (the app doesn't need to know whether the protein data came from the network or the offline cache)
// in this file we create the 3 objects for these 3 services and we use them :
class LigandRepository {
  final RcsbClient _client;
  final CifParser _parser;
  final LigandCache _cache;

  LigandRepository({
    RcsbClient? client,
    CifParser? parser,
    LigandCache? cache,
  })  : _client = client ?? RcsbClient(),
        _parser = parser ?? CifParser(),
        _cache = cache ?? LigandCache();

  // this method returns all the ligand codes = loads and parses the assets/data/ligands.txt and returns the plain list of ligand codes using rootBundle.loadString, then splitting on newlines and trimming blank entries
  Future<List<String>> loadLigandCodes() async {
    final raw = await rootBundle.loadString(AppConstants.ligandsAssetPath);
    return raw
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  // this method first checks if the requested protein is already in the cache, if not, it calls trhe http client to request, cache and parse it to a dart object
  // checks the "check _cache" first, if not in the cache, then call the "_client" then the "_parser", then must write the new raw text back into "_cache" before returning
  Future<Ligand> getLigand(String ligandCode) async {
    final cached = await _cache.read(ligandCode); // check if we have this protein in our cache

    // check where to get the protein raw file
    String rawCifText;
    if (cached != null) { // if the protein is on the cache 
      rawCifText = cached; // we just copy the cached file in this variable
    } else { // protein not cached = fetch it 
      rawCifText = await _client.fetchLigandCif(ligandCode);
    }

    // we parse the raw file
    final parser = _parser; // save the _parser in the "parser" variable to pass it to the new thread
    final ligand = await Isolate.run(() => parser.parse(rawCifText, ligandCode: ligandCode)); // parse on a background thread so the UI stays responsive

    // check if cache is needed
    if (cached == null) { // check that the protein is not in the cache already, before caching
      await _cache.write(ligandCode, rawCifText); // the app only saves the downloaded .cif file in its cache after we have successfully parsed it
    }
    // return the parsed object :
    return ligand;
  }
}
