import 'package:flutter/material.dart';
import 'package:fma/services/ApiService.dart';
import 'package:fma/templates/AppLocalization.dart';

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

      final List<Map<String, dynamic>> typedData =
          List<Map<String, dynamic>>.from(data);

      // Pair each transaction with its original index
      final indexedData = List.generate(typedData.length, (index) {
        return {'index': index, 'transaction': typedData[index]};
      });

      // Sort the transactions by date, preserving their original index
      indexedData.sort((a, b) {
        final transactionA = a['transaction'] as Map<String, dynamic>;
        final transactionB = b['transaction'] as Map<String, dynamic>;

        final dateA =
            DateTime.tryParse(transactionA['date'] ?? '') ?? DateTime.now();
        final dateB =
            DateTime.tryParse(transactionB['date'] ?? '') ?? DateTime.now();
        return dateB.compareTo(dateA); // Sorting in descending order
      });

      // Take the top 3 most recent transactions
      final topTransactions = indexedData.take(3).toList();

      setState(() {
        // We only want the transactions, not the index anymore
        transactions = topTransactions
            .map((e) =>
                {'originalIndex': e['index'], 'transaction': e['transaction']})
            .toList();
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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            localizations.translate("RecentTrans-label"),
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/transactions');
              },
              child: Text(localizations.translate("RecentTrans-label-title"),
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
                      final originalIndex = transaction['originalIndex'];
                      final transactionData = transaction[
                          'transaction']; // Access the transaction data

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
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
                            transactionData['title'] ??
                                '${localizations.translate("transactions-title")} $originalIndex', // Access transactionData['title']
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            transactionData['category'] ??
                                'No category', // Access transactionData['category']
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                          trailing: Text(
                            '${transactionData['type'] == 'income' ? '+' : '-'}\Rp.${transactionData['amount']},-', // Access transactionData['amount']
                            style: textTheme.bodyLarge?.copyWith(
                              color: transactionData['type'] == 'income'
                                  ? colorScheme.onSecondary
                                  : colorScheme.error,
                            ),
                          ),
                        ),
                      );
                    }),
      ],
    );
  }
}
