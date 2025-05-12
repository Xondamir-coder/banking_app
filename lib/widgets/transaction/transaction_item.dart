import 'package:banking_app/widgets/components/my_text.dart';
import 'package:banking_app/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel data;

  const TransactionItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  MyText(
                    'Date',
                    color: Theme.of(context).colorScheme.secondaryFixed,
                  ),
                  MyText(
                    DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    spacing: 6,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        'Category',
                        color: Theme.of(context).colorScheme.secondaryFixed,
                      ),
                      Icon(
                        data.category.iconData,
                        size: 15,
                        color: Theme.of(context).colorScheme.tertiaryFixedDim,
                      ),
                    ],
                  ),
                  MyText(
                    data.category.name,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    spacing: 6,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        'Amount',
                        color: Theme.of(context).colorScheme.secondaryFixed,
                      ),
                      Icon(
                        data.isCash
                            ? FontAwesome.money
                            : FontAwesome.credit_card,
                        size: 16, // match roughly the font-size
                        color: Theme.of(context).colorScheme.tertiaryFixedDim,
                      ),
                    ],
                  ),
                  MyText(
                    '${!data.isExpense ? '+' : '-'}${NumberFormat.currency(symbol: '', decimalDigits: 0).format(int.parse(data.amount))}',
                    color: !data.isExpense ? Colors.green : Colors.red,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
        ),
        if (data.description.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: MyText(
              'Description: ${data.description}',
            ),
          ),
      ],
    );
  }
}
