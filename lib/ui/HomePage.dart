import 'package:flutter/material.dart';
import 'package:fma/templates/CustomAppBar.dart';
import 'package:fma/templates/CustomBottomNavBar.dart';
import 'package:fma/templates/Themes.dart';
import 'package:fma/widgets/home/OverviewCard.dart';
import 'package:fma/widgets/home/QuickActions.dart';
import 'package:fma/widgets/home/RecentTransactions.dart';
import 'package:fma/widgets/home/SpendingTrends.dart';

class HomePage extends StatelessWidget {
  final VoidCallback toggleTheme;

  HomePage({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final gradientTheme = Theme.of(context).extension<GradientTheme>()!;
    final theme = Theme.of(context);
    final ColorScheme = theme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(title: 'Home', toggleTheme: toggleTheme),
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
                color: ColorScheme.primary,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                OverviewCard(),
                SizedBox(height: 20),
                QuickActions(),
                SizedBox(height: 20),
                RecentTransactions(),
                SizedBox(height: 20),
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
