import 'package:flutter/material.dart';
import 'package:fma/templates/AppLocalization.dart';

class SpendingTrends extends StatelessWidget {
  const SpendingTrends({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.translate("SpendTrends-label-title"),
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 10),
        Material(
          elevation: 5, // Add subtle elevation
          shadowColor: colorScheme.onSurface.withOpacity(0.4), // Softer shadow
          borderRadius: BorderRadius.circular(15),
          color: colorScheme.surface,
          child: Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0), // Padding inside container
            child: Center(
              child: Text(
                'Chart Placeholder', // Replace this with actual chart widget later
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
