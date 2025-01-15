import 'package:flutter/material.dart';
import 'package:fma/templates/AppLocalization.dart';

class OverviewCard extends StatelessWidget {
  final Future<double> incomeFuture;
  final Future<double> expenseFuture;
  final Future<double> netBalanceFuture;

  const OverviewCard({
    Key? key,
    required this.incomeFuture,
    required this.expenseFuture,
    required this.netBalanceFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      shadowColor: colorScheme.onSurface,
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              localizations.translate("overview-title"),
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatFuture(
                  context,
                  localizations.translate("overview-label-balance"),
                  netBalanceFuture,
                  colorScheme.onPrimary,
                ),
                _buildStatFuture(
                  context,
                  localizations.translate("overview-label-income"),
                  incomeFuture,
                  colorScheme.onSecondary,
                ),
                _buildStatFuture(
                  context,
                  localizations.translate("overview-label-expense"),
                  expenseFuture,
                  colorScheme.onTertiary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatFuture(BuildContext context, String label,
      Future<double> valueFuture, Color textColor) {
    return FutureBuilder<double>(
      future: valueFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.8)),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: textColor,
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return _buildStat(context, label, "Error", textColor);
        } else {
          final value = snapshot.data?.toStringAsFixed(2) ?? "0.00";
          return _buildStat(context, label, 'Rp. $value', textColor);
        }
      },
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
              .headlineSmall
              ?.copyWith(color: textColor),
        ),
      ],
    );
  }
}
