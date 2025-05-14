import 'package:banking_app/models/category_model.dart';
import 'package:banking_app/models/transaction_model.dart';
import 'package:banking_app/widgets/transaction/transaction_item.dart';
import 'package:banking_app/widgets/components/my_text.dart';
import 'package:banking_app/widgets/date_sorting/date_sorting_bar.dart';
import 'package:banking_app/widgets/sheets/category_sheet.dart';
import 'package:banking_app/widgets/sheets/transaction_sheet.dart';
import 'package:banking_app/widgets/transaction/transaction_total.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';

class TransactionsList extends StatefulWidget {
  final DocumentReference ref;

  const TransactionsList({required this.ref, super.key});

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  late Query _query;

  void sortBy(SortBy sortBy) {
    final now = DateTime.now();

    setState(() {
      DateTime? start;
      DateTime? end;

      switch (sortBy) {
        case (SortBy.day):
          start = DateTime(now.year, now.month, now.day);
          end = start.add(Duration(days: 1));
          break;
        case SortBy.week:
          // Assuming week starts on Monday. Adjust `.weekday` offset as needed.
          start = DateTime(now.year, now.month, now.day)
              .subtract(Duration(days: now.weekday - 1));
          end = start.add(Duration(days: 7));
          break;
        case SortBy.month:
          start = DateTime(now.year, now.month, 1);
          // next month’s first day:
          end = (now.month < 12)
              ? DateTime(now.year, now.month + 1, 1)
              : DateTime(now.year + 1, 1, 1);
          break;
        case SortBy.year:
          start = DateTime(now.year, 1, 1);
          end = DateTime(now.year + 1, 1, 1);
          break;
        case SortBy.all:
          // no time bounds
          _query = widget.ref.collection('transactions').orderBy('timestamp');
          return;
      }

      _query = widget.ref
          .collection('transactions')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('timestamp', isLessThan: Timestamp.fromDate(end))
          .orderBy('timestamp');
    });
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final startOfTomorrow = startOfDay.add(Duration(days: 1));
    _query = widget.ref
        .collection('transactions')
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where(
          'timestamp',
          isLessThan: Timestamp.fromDate(startOfTomorrow),
        )
        .orderBy('timestamp');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              'Transactions',
              fontSize: 18,
            ),
            IconButton(
              onPressed: () async {
                try {
                  final CategoryModel category = await showModalBottomSheet(
                    context: context,
                    builder: (context) => CategorySheet(),
                  );
                  if (!context.mounted) return;
                  final TransactionModel transactionData =
                      await showModalBottomSheet(
                    context: context,
                    builder: (ctx) => TransactionSheet(category: category),
                  );
                  widget.ref
                      .collection('transactions')
                      .add(transactionData.toMap());
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Sheet is closed'),
                    ),
                  );
                }
              },
              icon: Icon(
                AntDesign.pluscircle,
              ),
            ),
          ],
        ),
        DateSortingBar(
          onSort: sortBy,
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _query.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: MyText(
                  'Something went wrong',
                  fontSize: 20,
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final transactions = snapshot.data!.docs
                .map(
                  (doc) => TransactionModel.fromMap(
                      doc.data() as Map<String, dynamic>),
                )
                .toList();

            if (transactions.isEmpty) {
              return const Center(
                child: MyText(
                  'No transactions present',
                  fontSize: 20,
                ),
              );
            }

            return Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (ctx, index) => Dismissible(
                        key: ValueKey(index),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          snapshot.data!.docs[index].reference.delete();
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Theme.of(context).colorScheme.error,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: TransactionItem(
                          data: transactions[index],
                        ),
                      ),
                      separatorBuilder: (ctx, index) => const Divider(
                        height: 30,
                      ),
                      itemCount: transactions.length,
                    ),
                  ),
                  TransactionTotal(
                    totalAmount: transactions.fold(
                      0,
                      (prev, element) => element.isExpense
                          ? prev - int.parse(element.amount)
                          : prev + int.parse(element.amount),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
