import 'package:flutter/material.dart';

class FilterButtons extends StatelessWidget {
  const FilterButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFilterButton(context, Icons.date_range, 'Date'),
        _buildFilterButton(context, Icons.category, 'Category'),
        _buildFilterButton(context, Icons.swap_horiz, 'Type'),
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
