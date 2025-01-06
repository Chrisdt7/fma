import 'package:flutter/material.dart';
import 'chart/ChartHelper.dart';
import 'chart/ChartUtils.dart';

class ChartDisplay extends StatelessWidget {
  final List<Map<String, dynamic>> chartData;
  final double chartHeight;
  final int meterSteps;

  const ChartDisplay({
    Key? key,
    required this.chartData,
    this.chartHeight = 200.0,
    this.meterSteps = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final maxIncome = chartData.fold(
        0.0, (max, item) => item['income'] > max ? item['income'] : max);
    final maxExpense = chartData.fold(
        0.0, (max, item) => item['expense'] > max ? item['expense'] : max);
    final maxValue = calculateMaxValue(maxIncome, maxExpense);
    final meterValues = generateMeterValues(maxValue, meterSteps);

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(12),
      color: colorScheme.surface,
      child: Container(
        height: chartHeight + 70,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: chartData.isEmpty
            ? buildEmptyState(context, colorScheme, textTheme)
            : Stack(
                children: [
                  buildGridLines(meterValues, colorScheme, chartHeight),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      buildMeter(meterValues, textTheme, colorScheme),
                      Expanded(
                        child: buildBars(
                            chartData, maxValue, colorScheme, chartHeight),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
