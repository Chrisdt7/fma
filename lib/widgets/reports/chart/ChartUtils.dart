double calculateMaxValue(double maxIncome, double maxExpense) {
  final maxValue = maxIncome > maxExpense ? maxIncome : maxExpense;
  return (maxValue / 10000).ceil() * 10000;
}

List<double> generateMeterValues(double maxValue, int meterSteps) {
  if (maxValue == 0) return List.generate(meterSteps, (_) => 0.0);
  final step = maxValue / (meterSteps - 1);
  return List.generate(meterSteps, (i) => step * i).reversed.toList();
}

double calculateBarHeight(double value, double maxValue, double chartHeight) {
  if (maxValue == 0) return 0.0;
  return (value / maxValue) * chartHeight;
}
