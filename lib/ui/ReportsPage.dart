import 'package:flutter/material.dart';
import 'package:fma/templates/Themes.dart';
import 'package:fma/templates/CustomAppBar.dart';
import 'package:fma/templates/CustomBottomNavBar.dart';
import 'package:fma/widgets/reports/ReportCard.dart';
import 'package:fma/widgets/reports/ChartDisplay.dart';
import 'package:fma/widgets/reports/DateSelector.dart';
import 'package:fma/services/ApiService.dart';
import 'package:intl/intl.dart';
import 'package:fma/services/ExportService.dart';

class ReportsPage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const ReportsPage({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  double _income = 0.0;
  double _expense = 0.0;
  double _netBalance = 0.0;
  List<Map<String, dynamic>> _chartData = [];
  final ApiService _apiService = ApiService();
  final ExportService _exportService = ExportService();

  bool _isLoading = false;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  void _fetchReports(DateTime start, DateTime end) async {
    setState(() {
      _isLoading = true;
      _selectedStartDate = start;
      _selectedEndDate = end;
    });

    try {
      final results = await Future.wait([
        _apiService.getIncomeReport(DateFormat('yyyy-MM-dd').format(start),
            DateFormat('yyyy-MM-dd').format(end)),
        _apiService.getExpenseReport(DateFormat('yyyy-MM-dd').format(start),
            DateFormat('yyyy-MM-dd').format(end)),
        _apiService.getChartData(DateFormat('yyyy-MM-dd').format(start),
            DateFormat('yyyy-MM-dd').format(end))
      ]);

      setState(() {
        _isLoading = false;
        _income = results[0] as double;
        _expense = results[1] as double;
        _netBalance = _income - _expense;
        _chartData = results[2] as List<Map<String, dynamic>>;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data: $e')),
      );
    }
  }

  Future<void> _exportData() async {
    if (_selectedStartDate == null || _selectedEndDate == null) {
      _showSnackBar('Please select a date range first!', context);
      return;
    }

    try {
      await _exportService.exportToPDF(
        income: _income,
        expense: _expense,
        netBalance: _netBalance,
        chartData: _chartData,
        startDate: _selectedStartDate,
        endDate: _selectedEndDate,
      );

      await _exportService.exportToExcel(
        income: _income,
        expense: _expense,
        netBalance: _netBalance,
        chartData: _chartData,
        startDate: _selectedStartDate,
        endDate: _selectedEndDate,
      );

      _showSnackBar('Data Exported Successfully', context, isSuccess: true);
    } catch (e) {
      _showSnackBar('Failed To Export Data.', context);
    }
  }

  void _showSnackBar(String message, BuildContext context,
      {bool isSuccess = false}) {
    final colorScheme = Theme.of(context).colorScheme;

    final snackBar = SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
      ),
      backgroundColor: isSuccess
          ? Theme.of(context).colorScheme.onSecondary
          : Theme.of(context).colorScheme.error,
      behavior: Theme.of(context).snackBarTheme.behavior,
      shape: Theme.of(context).snackBarTheme.shape,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final gradientTheme = Theme.of(context).extension<GradientTheme>()!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(title: 'Reports', toggleTheme: widget.toggleTheme),
      body: Stack(
        children: [
          Container(
            decoration:
                BoxDecoration(gradient: gradientTheme.backgroundGradient),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DateSelector(
                        onDateSelected: _fetchReports,
                        selectedStartDate: _selectedStartDate,
                        selectedEndDate: _selectedEndDate,
                      ),
                      const SizedBox(height: 20),
                      ChartDisplay(chartData: _chartData),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: ReportCard(
                            title: 'Income Report',
                            value: '\Rp.${_income.toStringAsFixed(2)},-',
                            valueColor: colorScheme.onSecondary,
                          )),
                          Expanded(
                              child: ReportCard(
                            title: 'Expense Report',
                            value: '-\Rp.${_expense.toStringAsFixed(2)},-',
                            valueColor: colorScheme.onTertiary,
                          )),
                        ],
                      ),
                      Container(
                        width: double.maxFinite,
                        child: ReportCard(
                          title: 'Net Balance',
                          value: '\Rp.${_netBalance.toStringAsFixed(2)},-',
                          valueColor:
                              _netBalance >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _exportData,
                          icon: Icon(Icons.download),
                          label: Text('Export Data'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
