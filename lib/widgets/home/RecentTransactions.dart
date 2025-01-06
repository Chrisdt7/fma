import 'package:flutter/material.dart';
import 'package:fma/services/ApiService.dart';

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({Key? key}) : super(key: key);

  @override
  _RecentTransactionsState createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  List<dynamic> transactions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchRecentTransactions();
  }

  Future<void> fetchRecentTransactions() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final apiService = ApiService();
      final data = await apiService.getTransactions();

      // Sort and take the most recent 3 transactions
      final sortedData = List.from(data)
        ..sort((a, b) => b['date'].compareTo(a['date']));
      setState(() {
        transactions = sortedData.take(3).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage =
            'Failed to load recent transactions. Please try again later.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            'Recent Transactions',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/transactions');
              },
              child: Text('View all',
                  style: textTheme.headlineSmall
                      ?.copyWith(color: colorScheme.onSurface))),
        ]),
        const SizedBox(height: 10),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: colorScheme.error),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5), // Optional spacing between items
                        decoration: BoxDecoration(
                          color: colorScheme
                              .surface, // Background color for the item
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
                            child: Icon(
                              Icons.receipt,
                              color: colorScheme.tertiary,
                            ),
                          ),
                          title: Text(
                            transaction['title'] ?? 'Transaction ${index + 1}',
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            transaction['category'] ?? 'No category',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                          trailing: Text(
                            '${transaction['type'] == 'income' ? '+' : '-'}\Rp.${transaction['amount']},-',
                            style: textTheme.bodyLarge?.copyWith(
                              color: transaction['type'] == 'income'
                                  ? colorScheme.onSecondary
                                  : colorScheme.error,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ],
    );
  }
}
