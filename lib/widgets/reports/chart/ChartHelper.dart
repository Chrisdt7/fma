import 'package:flutter/material.dart';
import 'ChartUtils.dart';

Widget buildEmptyState(
    BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
  return Center(
    child: Text(
      'No Data Available',
      style: textTheme.headlineMedium?.copyWith(color: colorScheme.primary),
    ),
  );
}

Widget buildGridLines(
    List<double> meterValues, ColorScheme colorScheme, double chartHeight) {
  return Stack(
    children: meterValues.map((value) {
      final yOffset = calculateBarHeight(value, meterValues.first, chartHeight);
      return Positioned(
        bottom: yOffset + 15,
        left: 0,
        right: 0,
        child: Divider(
          color: colorScheme.onSurface.withOpacity(0.2),
          thickness: 1,
        ),
      );
    }).toList(),
  );
}

Widget buildMeter(
    List<double> meterValues, TextTheme textTheme, ColorScheme colorScheme) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: meterValues.map((value) {
            return Text(
              value.toStringAsFixed(0),
              style:
                  textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
            );
          }).toList(),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Date',
        style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurface),
      ),
    ],
  );
}

Widget buildBars(List<Map<String, dynamic>> chartData, double maxValue,
    ColorScheme colorScheme, double chartHeight) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: chartData.map((data) {
      final income = data['income'] ?? 0.0;
      final expense = data['expense'] ?? 0.0;
      final date = data['date'] ?? '';
      return buildBarGroup(
          maxValue, income, expense, date, colorScheme, chartHeight);
    }).toList(),
  );
}

Widget buildBarGroup(double maxValue, double income, double expense,
    String date, ColorScheme colorScheme, double chartHeight) {
  final incomeHeight = calculateBarHeight(income, maxValue, chartHeight);
  final expenseHeight = calculateBarHeight(expense, maxValue, chartHeight);
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Tooltip(
        message: 'Income: Rp.$income,-\nExpense: Rp.$expense,-',
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            buildBar(
                height: incomeHeight, color: colorScheme.onSecondaryContainer),
            const SizedBox(width: 4),
            buildBar(height: expenseHeight, color: colorScheme.error),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Text(date, style: TextStyle(fontSize: 10, color: colorScheme.onSurface)),
    ],
  );
}

Widget buildBar({required double height, required Color color}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    height: height,
    width: 20,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}
