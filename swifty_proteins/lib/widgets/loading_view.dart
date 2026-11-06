import 'package:flutter/material.dart';

// The reusable "loading spinner" with an optional message, used by every screen that waits on an async operation

class LoadingView extends StatelessWidget {
  final String? message; // optional

// constructor
  const LoadingView({super.key, this.message});

// spinner layout
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(), // the spinner
          // the optional message under the spinner :
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(message!), // ! = this value is not null
          ],
        ],
      ),
    );
  }
}
