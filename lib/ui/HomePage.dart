import 'package:flutter/material.dart';
import 'package:fma/services/ApiService.dart';
import 'package:fma/templates/AppLocalization.dart';
import 'package:fma/templates/CustomAppBar.dart';
import 'package:fma/templates/CustomBottomNavBar.dart';
import 'package:fma/templates/Themes.dart';
import 'package:fma/widgets/home/OverviewCard.dart';
import 'package:fma/widgets/home/QuickActions.dart';
import 'package:fma/widgets/home/RecentTransactions.dart';
import 'package:fma/widgets/home/SpendingTrends.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> transactions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final apiService = ApiService();
      final data = await apiService.getTransactions();
      setState(() {
        transactions = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = AppLocalizations.of(context)
            .translate("snackbarFailedGetTransactions");
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientTheme = Theme.of(context).extension<GradientTheme>()!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
          title: localizations.translate('home-title'),
          toggleTheme: widget.toggleTheme),
      body: Stack(
        children: [
          Container(
            decoration:
                BoxDecoration(gradient: gradientTheme.backgroundGradient),
          ),
          Center(
            child: Opacity(
              opacity: 0.3,
              child: Icon(
                Icons.home,
                size: 300,
                color: colorScheme.primary,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OverviewCard(
                  incomeFuture: ApiService().getAllIncomeReports(),
                  expenseFuture: ApiService().getAllExpenseReports(),
                  netBalanceFuture: ApiService().getAllNetBalances(),
                ),
                const SizedBox(height: 20),
                QuickActions(fetchTransactions: fetchTransactions),
                const SizedBox(height: 20),
                const RecentTransactions(),
                const SizedBox(height: 20),
                SpendingTrends(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
