import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatelessWidget {
  final Function(DateTime start, DateTime end) onDateSelected;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;

  const DateSelector({
    Key? key,
    required this.onDateSelected,
    this.selectedStartDate,
    this.selectedEndDate,
  }) : super(key: key);

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: selectedStartDate != null && selectedEndDate != null
          ? DateTimeRange(start: selectedStartDate!, end: selectedEndDate!)
          : null,
    );

    if (picked != null) {
      onDateSelected(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    String dateText = selectedStartDate != null && selectedEndDate != null
        ? "${DateFormat.yMMM().format(selectedStartDate!)} - ${DateFormat.yMMM().format(selectedEndDate!)}"
        : "Select Date Range";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () => _selectDateRange(context),
          child: const Text('Select Date'),
        ),
        Text(
          dateText,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ],
    );
  }
}
