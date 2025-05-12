import 'package:banking_app/widgets/transaction/transaction_item.dart';
import 'package:banking_app/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (ctx, index) => TransactionItem(data: transactions[index]),
        separatorBuilder: (ctx, index) => const Divider(
          height: 30,
        ),
        itemCount: transactions.length,
      ),
    );
  }
}
