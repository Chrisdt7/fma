import 'package:flutter/material.dart';
import 'package:fma/services/ApiService.dart';
import 'package:fma/services/Helpers.dart';
import 'package:fma/templates/AppLocalization.dart';
import 'package:fma/widgets/transactions/AddTransactionDialog.dart';

class QuickActions extends StatelessWidget {
  final Future<void> Function() fetchTransactions;

  const QuickActions({Key? key, required this.fetchTransactions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildQuickAction(
          context,
          Icons.add,
          AppLocalizations.of(context).translate("QuickAct-label-title-1"),
          onTap: () async {
            // Open AddTransactionDialog
            final result = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (BuildContext context) {
                return AddTransactionDialog();
              },
            );

            if (result != null && result.isNotEmpty) {
              final apiService = ApiService();
              final success = await apiService.addTransaction(
                result['amount'],
                result['category'],
                result['type'],
                result['date'],
              );
              
              await fetchTransactions();

              if (success) {
                showSnackBar(
                    context,
                    AppLocalizations.of(context)
                        .translate("snackbarSuccessAddTransactions"),
                    isSuccess: true);
              } else {
                showSnackBar(
                    context,
                    AppLocalizations.of(context)
                        .translate("snackbarFailedAddTransactions"),
                    isSuccess: false);
              }
            }
          },
        ),
        _buildQuickAction(
          context,
          Icons.pie_chart,
          AppLocalizations.of(context).translate("QuickAct-label-title-2"),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/reports');
          },
        ),
        _buildQuickAction(
          context,
          Icons.analytics,
          AppLocalizations.of(context).translate("QuickAct-label-title-3"),
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
