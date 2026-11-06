import 'package:flutter/material.dart';

import '../../models/atom.dart';

// This page represennts a small pop-up shown when an atom is tapped in the 3D view (it disappears when the user taps elsewhere or taps a different atom)

class AtomInfoOverlay extends StatelessWidget {
  final Atom atom;
  final VoidCallback onDismiss;

  const AtomInfoOverlay({
    super.key,
    required this.atom,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text('${atom.element} (${atom.id})'),
        ),
      ),
    );
  }
}
