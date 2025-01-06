import 'package:flutter/material.dart';
import 'package:fma/templates/Themes.dart';
import 'package:fma/templates/CustomAppBar.dart';
import 'package:fma/templates/CustomBottomNavBar.dart';
import 'package:fma/widgets/transactions/AddTransactionDialog.dart';
import 'package:fma/widgets/transactions/SearchBar.dart' as custom;
import 'package:fma/widgets/transactions/FilterButtons.dart';
import 'package:fma/widgets/transactions/TransactionItem.dart';
import 'package:fma/services/ApiService.dart';

class TransactionsPage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const TransactionsPage({Key? key, required this.toggleTheme})
      : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
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
        errorMessage = 'Failed to load transactions. Please try again later.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final gradientTheme = Theme.of(context).extension<GradientTheme>()!;

    return Scaffold(
      appBar:
          CustomAppBar(title: 'Transactions', toggleTheme: widget.toggleTheme),
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
                Icons.receipt,
                size: 300,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Column(
            children: [
              const custom.SearchBar(),
              const SizedBox(height: 16),
              const FilterButtons(),
              const SizedBox(height: 16),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage.isNotEmpty
                        ? Center(
                            child: Text(errorMessage,
                                style: TextStyle(color: Colors.red)))
                        : ListView.builder(
                            itemCount: transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = transactions[index];
                              return TransactionItem(
                                type: transaction['type'],
                                title: 'Transaction ${transaction['id']}',
                                subtitle: transaction['category'],
                                amount: transaction['amount'].toString(),
                              );
                            },
                          ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Open dialog to add a new transaction
          final result = await showDialog<Map<String, dynamic>>(
            context: context,
            builder: (BuildContext context) {
              return AddTransactionDialog();
            },
          );

          // If dialog returns valid data, add the transaction
          if (result != null) {
            try {
              final apiService = ApiService();
              final success = await apiService.addTransaction(
                result['amount'],
                result['category'],
                result['type'],
                result['date'],
              );

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Transaction added successfully!')),
                );
                fetchTransactions();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to add transaction.')),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('An error occurred: $e')),
              );
            }
          }
        },
        backgroundColor: colorScheme.surface.withAlpha(200),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: colorScheme.surface.withAlpha(50))),
        elevation: 10,
        tooltip: 'Add Transaction',
        child: Icon(Icons.add, color: colorScheme.onPrimary),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
