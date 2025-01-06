import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String type;

  const TransactionItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 3,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              spreadRadius: 2,
              color: colorScheme.onPrimary,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: colorScheme.surface,
            child: Icon(Icons.receipt, color: colorScheme.tertiary),
          ),
          title: Text(
            title,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface, // Adapt to surface contrast
            ),
          ),
          subtitle: Text(
            subtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8), // Softer tone
            ),
          ),
          trailing: Text(
            '${type == 'income' ? '+' : '-'}\Rp.$amount,-',
            style: textTheme.bodyLarge?.copyWith(
              color: type == 'income'
                  ? colorScheme.onSecondary
                  : colorScheme.error,
            ),
          ),
          onTap: () {
            // Navigate to transaction details
          },
        ),
      ),
    );
  }
}
