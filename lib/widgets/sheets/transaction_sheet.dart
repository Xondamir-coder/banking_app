import 'package:banking_app/models/category_model.dart';
import 'package:banking_app/widgets/components/my_text.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';

class TransactionSheet extends StatefulWidget {
  final CategoryModel category;

  const TransactionSheet({
    super.key,
    required this.category,
  });

  @override
  State<TransactionSheet> createState() => _TransactionSheetState();
}

class _TransactionSheetState extends State<TransactionSheet> {
  var _isExpense = true;
  final _isCash = true;

  final amountTextController = TextEditingController();
  final descTextController = TextEditingController();

  @override
  void dispose() {
    amountTextController.dispose();
    descTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        spacing: 12,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                '* Transaction Type',
              ),
              Row(
                children: [
                  Checkbox.adaptive(
                    value: _isExpense,
                    onChanged: (value) {
                      setState(() {
                        _isExpense = true;
                      });
                    },
                  ),
                  const MyText('Income', color: Colors.green),
                  Checkbox.adaptive(
                    value: !_isExpense,
                    onChanged: (value) {
                      setState(() {
                        _isExpense = false;
                      });
                    },
                  ),
                  const MyText('Expense', color: Colors.red),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                '* Payment Method',
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isCash,
                    onChanged: (value) {
                      setState(() {
                        _isCash;
                      });
                    },
                  ),
                  const Icon(
                    FontAwesome.money,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Checkbox(
                    value: !_isCash,
                    onChanged: (value) {
                      setState(() {
                        !_isCash;
                      });
                    },
                  ),
                  const Icon(
                    FontAwesome.credit_card,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: '* Amount',
            ),
            controller: amountTextController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
            controller: descTextController,
            keyboardType: TextInputType.text,
          ),
          ElevatedButton(
            child: const MyText('Submit'),
            onPressed: () async {
              final amount = amountTextController.text.trim();
              final desc = descTextController.text.trim();
              if (amount.isEmpty) return;
              try {
                //  DbOperations.addTransaction(board, transaction)
              } catch (e) {}
              // final budget = TransactionModel(
              //   amount: amount,
              //   category: widget.category,
              //   isExpense: _isExpense,
              //   isCash: _isCash,
              //   description: desc,
              // );
              // Navigator.of(context).pop(budget);
            },
          ),
          Spacer(),
          Column(
            spacing: 6,
            children: [
              Row(
                spacing: 10,
                children: [
                  Icon(
                    FontAwesome.money,
                    size: 18,
                  ),
                  MyText('= Cash'),
                ],
              ),
              Row(
                spacing: 10,
                children: [
                  Icon(
                    FontAwesome.credit_card,
                    size: 18,
                  ),
                  MyText('= Card'),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
