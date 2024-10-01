import 'package:flutter/material.dart';
import 'package:fraud_mobile/providers/transaction_provider.dart';

class TransactionSearchDelegate extends SearchDelegate {
  final TransactionProvider transactionProvider;

  TransactionSearchDelegate(this.transactionProvider);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // You can implement logic to show results based on the query
    final results = transactionProvider.transactions.where((transaction) {
      return transaction.description!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final transaction = results[index];
        return ListTile(
          title: Text(transaction.description!),
          subtitle: Text(transaction.amount.toString()),
          onTap: () {
            // Implement the action when a transaction is tapped
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // You can implement logic to show suggestions while typing
    return Container();
  }
}
