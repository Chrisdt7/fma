import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme; // Fetching color scheme

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      shadowColor: colorScheme.onSurface,
      color: colorScheme.surface, // Using surface color from theme
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Financial Overview',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(
                    context, 'Balance', '\$12,340', colorScheme.onPrimary),
                _buildStat(
                    context, 'Income', '\$4,200', colorScheme.onSecondary),
                _buildStat(
                    context, 'Expenses', '\$2,950', colorScheme.onTertiary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
      BuildContext context, String label, String value, Color textColor) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: colorScheme.onSurface.withOpacity(0.8)),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: textColor), // Apply the custom color here
        ),
      ],
    );
  }
}
