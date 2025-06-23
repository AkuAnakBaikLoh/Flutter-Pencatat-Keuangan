import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart'; // Sesuaikan dengan path modelmu

class DetailTransactionPage extends StatelessWidget {
  final String title;
  final List<TransactionModel> transactions;

  const DetailTransactionPage({
    super.key,
    required this.title,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return ListTile(
            leading: Icon(
              tx.isExpense ? Icons.upload : Icons.download,
              color: tx.isExpense ? Colors.red : Colors.green,
            ),
            title: Text("Rp. ${tx.amount.toStringAsFixed(0)}"),
            subtitle: Text(
              "${tx.category} - ${DateFormat('dd MMM yyyy').format(tx.date)}",
            ),
          );
        },
      ),
    );
  }
}
