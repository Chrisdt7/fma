import 'package:flutter/material.dart';
import 'package:fma/widgets/transactions/AddTransactionDialog.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildQuickAction(
          context,
          Icons.add,
          'Add\nTransaction',
          onTap: () async {
            // Open AddTransactionDialog
            final result = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (BuildContext context) {
                return AddTransactionDialog();
              },
            );

            if (result != null) {
              // Process the result or display a message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Transaction added successfully!')),
              );
            }
          },
        ),
        _buildQuickAction(
          context,
          Icons.pie_chart,
          'View\nReports',
        ),
        _buildQuickAction(
          context,
          Icons.analytics,
          'Analyze\nTrends',
        ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String label, {
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: colorScheme.surface.withAlpha(150),
            child: Icon(
              icon,
              color: colorScheme.onPrimary, // Using onPrimary for contrast
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
