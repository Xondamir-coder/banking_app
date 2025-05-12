import 'package:banking_app/widgets/components/my_text.dart';
import 'package:banking_app/widgets/date_sorting/date_sorting_bar.dart';
import 'package:flutter/material.dart';

class DateSortingButton extends StatelessWidget {
  final bool isSelected;
  final SortingModel data;
  final Function(SortBy) onTap;

  const DateSortingButton({
    super.key,
    required this.data,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).appBarTheme.backgroundColor
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () => onTap(data.sortBy),
      child: MyText(
        data.title,
        color: isSelected
            ? Theme.of(context).colorScheme.onSecondaryContainer
            : Colors.white,
      ),
    );
  }
}
