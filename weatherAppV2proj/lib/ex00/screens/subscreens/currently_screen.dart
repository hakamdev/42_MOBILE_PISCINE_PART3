import 'package:flutter/material.dart';

class CurrentlyScreen extends StatelessWidget {
  const CurrentlyScreen({super.key, required this.displayText});
  final String displayText;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Currently",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (displayText.isNotEmpty)
            const SizedBox(height: 8),
            if (displayText.isNotEmpty)
              Text(
                displayText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
          ],
        ),
      ),
    );
  }
}
