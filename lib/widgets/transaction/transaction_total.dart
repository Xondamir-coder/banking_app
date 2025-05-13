import 'package:banking_app/widgets/components/my_text.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:intl/intl.dart';

class TransactionTotal extends StatelessWidget {
  final int totalAmount;

  const TransactionTotal({required this.totalAmount, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            totalAmount >= 0
                ? FontAwesome.arrow_circle_up
                : FontAwesome.arrow_circle_down,
            color: totalAmount >= 0 ? Colors.green : Colors.red,
          ),
          MyText(
            '${totalAmount > 0 ? '+' : ''}${NumberFormat.currency(symbol: '', decimalDigits: 0).format(totalAmount)}',
            color: totalAmount >= 0 ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}
