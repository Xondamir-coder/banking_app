import 'package:banking_app/widgets/date_sorting/date_sorting_button.dart';
import 'package:flutter/material.dart';

enum SortBy {
  day,
  week,
  month,
  year,
  all,
}

class SortingModel {
  final SortBy sortBy;
  final String title;
  SortingModel({
    required this.sortBy,
    required this.title,
  });
}

final sortingArray = [
  SortingModel(sortBy: SortBy.day, title: 'Daily'),
  SortingModel(sortBy: SortBy.week, title: 'Weekly'),
  SortingModel(sortBy: SortBy.month, title: 'Monthly'),
  SortingModel(sortBy: SortBy.year, title: 'Yearly'),
  SortingModel(sortBy: SortBy.all, title: 'All'),
];

class DateSortingBar extends StatefulWidget {
  final Function(SortBy) onSort;

  const DateSortingBar({super.key, required this.onSort});

  @override
  State<DateSortingBar> createState() => _DateSortingBarState();
}

class _DateSortingBarState extends State<DateSortingBar> {
  var selectedSortBy = SortBy.day;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        itemBuilder: (ctx, index) => DateSortingButton(
          data: sortingArray[index],
          onTap: (SortBy sortBy) {
            setState(() {
              selectedSortBy = sortBy;
            });
            widget.onSort(sortBy);
          },
          isSelected: selectedSortBy == sortingArray[index].sortBy,
        ),
        separatorBuilder: (ctx, index) => const SizedBox(width: 10),
        scrollDirection: Axis.horizontal,
        itemCount: sortingArray.length,
      ),
    );
  }
}
