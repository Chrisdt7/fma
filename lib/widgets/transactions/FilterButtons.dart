import 'package:flutter/material.dart';
import 'package:fma/templates/AppLocalization.dart';

class FilterButtons extends StatelessWidget {
  const FilterButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFilterButton(context, Icons.date_range,
            localizations.translate("AddTransaction-label-Date")),
        _buildFilterButton(context, Icons.category,
            localizations.translate("Transactions-label-category")),
        _buildFilterButton(context, Icons.swap_horiz,
            localizations.translate("Transactions-label-type")),
      ],
    );
  }

  Widget _buildFilterButton(BuildContext context, IconData icon, String label) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton.icon(
      onPressed: () {
        // Show filter options
      },
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
