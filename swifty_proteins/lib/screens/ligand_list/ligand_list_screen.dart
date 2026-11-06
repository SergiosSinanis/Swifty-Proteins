import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';
import '../../state/ligand_detail_state.dart';
import '../../state/ligand_list_state.dart';
import 'widgets/ligand_tile.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/navy_background.dart';

// this is the page with the list of all the proteins

class LigandListScreen extends StatefulWidget {
  const LigandListScreen({super.key});

  @override
  State<LigandListScreen> createState() => _LigandListScreenState();
}

class _LigandListScreenState extends State<LigandListScreen> {
  bool _isOpeningLigand = false; // true while a ligand is loading : shows the spinner and blocks a 2nd tap

  @override
  void initState() {
    super.initState();
    // notifyListeners() is forbidden while the first build runs, so we wait for it to end
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LigandListState>().loadCodes();
      }
    });
  }

  // the ligand is loaded HERE, before opening the 3D screen : on failure the user stays on the list and sees a pop-up
  Future<void> _openLigand(String code) async {
    if (_isOpeningLigand) return;
    FocusScope.of(context).unfocus(); // closes the keyboard of the search bar
    setState(() {
      _isOpeningLigand = true;
    });

    final detailState = context.read<LigandDetailState>();
    await detailState.load(code);
    if (!mounted) return;
    setState(() {
      _isOpeningLigand = false;
    });

    if (detailState.status == LigandLoadStatus.success) {
      Navigator.of(context).pushNamed(AppRoutes.proteinView, arguments: code);
    } else {
      ErrorDialog.show(
        context,
        title: 'Could not load $code',
        message: detailState.errorMessage ?? 'Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final listState = context.watch<LigandListState>();

    final listContent = Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Search a ligand',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                listState.updateQuery(value); // user typed something (value) and we send it to the LigandListState (updateQuery)
              },
            ),

            const SizedBox(height: 16),

            if (listState.isLoading)
              const Expanded(
                child: LoadingView(message: 'Loading ligands...'),
            )
            else if (listState.filteredCodes.isEmpty)
              const Expanded(child: Center(child: Text('No ligand found')))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: listState.filteredCodes.length,
                  itemBuilder: (context, index) {
                    final code = listState.filteredCodes[index];
                    return LigandTile(
                      key: ValueKey(code),
                      code: code,
                      onTap: () => _openLigand(code),
                    );
                  },
                ),
              ),
          ],
        ),
      );

    // while a ligand loads, a dark layer with a spinner covers the list
    final layers = <Widget>[listContent];
    if (_isOpeningLigand) {
      layers.add(const Positioned.fill(
        child: ColoredBox(
          color: Colors.black38,
          child: LoadingView(message: 'Loading ligand...'),
        ),
      ));
    }

    // the white texts, the search field and the bar come from app_theme.dart
    return NavyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent, // the gradient painted by NavyBackground shows through
        appBar: AppBar(title: const Text('Ligands')),
        body: Stack(children: layers),
      ),
    );
  }
}
