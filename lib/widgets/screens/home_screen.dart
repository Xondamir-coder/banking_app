import 'package:banking_app/models/category_model.dart';
import 'package:banking_app/widgets/transaction/budget_list.dart';
import 'package:banking_app/widgets/components/my_text.dart';
import 'package:banking_app/data/budget_data.dart';
import 'package:banking_app/widgets/date_sorting/date_sorting_bar.dart';
import 'package:banking_app/widgets/sheets/category_sheet.dart';
import 'package:banking_app/widgets/sheets/transaction_sheet.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void sortBy(SortBy sortBy) {
    // setState(() {
    //   if (sortBy == SortBy.day) {
    //     budget = budgetData
    //         .where((element) =>
    //             element.date.day == DateTime.now().day &&
    //             element.date.month == DateTime.now().month &&
    //             element.date.year == DateTime.now().year)
    //         .toList();
    //   } else if (sortBy == SortBy.week) {
    //     int currentWeek = DateTime.now().weekday;
    //     budget = budgetData
    //         .where((element) =>
    //             element.date.weekday == currentWeek &&
    //             element.date.year == DateTime.now().year)
    //         .toList();
    //   } else if (sortBy == SortBy.month) {
    //     int currentMonth = DateTime.now().month;
    //     budget = budgetData
    //         .where((element) =>
    //             element.date.month == currentMonth &&
    //             element.date.year == DateTime.now().year)
    //         .toList();
    //   } else if (sortBy == SortBy.year) {
    //     int currentYear = DateTime.now().year;
    //     budget = budgetData
    //         .where((element) => element.date.year == currentYear)
    //         .toList();
    //   } else {
    //     budget = budgetData;
    //   }
    //   budget.sort((a, b) => a.date.compareTo(b.date));
    // });
  }

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   budget = budgetData
    //       .where((element) =>
    //           element.date.day == DateTime.now().day &&
    //           element.date.month == DateTime.now().month &&
    //           element.date.year == DateTime.now().year)
    //       .toList();
    //   budget.sort((a, b) => a.date.compareTo(b.date));
    // });
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = budgetData.fold(
      0,
      (prev, element) => element.isExpense
          ? prev - int.parse(element.amount)
          : prev + int.parse(element.amount),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyText(
          'Transactions',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                final CategoryModel category = await showModalBottomSheet(
                  context: context,
                  builder: (context) => CategorySheet(),
                );
                if (!context.mounted) return;
                final data = await showModalBottomSheet(
                  context: context,
                  builder: (ctx) => TransactionSheet(category: category),
                );
                // setState(() {
                //   budget.add(data);
                // });
              } catch (e) {
                print('Sheet is closed');
              }
            },
            icon: Icon(
              AntDesign.pluscircle,
            ),
          ),
        ],
      ),
      body: budgetData.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 10,
                children: [
                  DateSortingBar(onSort: sortBy),
                  Expanded(
                    child: Column(
                      children: [
                        BudgetList(transactions: budgetData),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Row(
                            spacing: 5,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                totalAmount >= 0
                                    ? FontAwesome.arrow_circle_up
                                    : FontAwesome.arrow_circle_down,
                                color: totalAmount >= 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              MyText(
                                '${totalAmount > 0 ? '+' : ''}${NumberFormat.currency(symbol: '', decimalDigits: 0).format(totalAmount)}',
                                color: totalAmount >= 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: Text('No transactions'),
            ),
    );
  }
}
