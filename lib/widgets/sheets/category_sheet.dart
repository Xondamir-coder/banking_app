import 'package:banking_app/data/categories_data.dart';
import 'package:banking_app/widgets/components/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_flutter/icons_flutter.dart';

class CategorySheet extends StatelessWidget {
  const CategorySheet({super.key});

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
      child: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(5),
        children: [
          for (final category in categories)
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Theme.of(context).appBarTheme.backgroundColor,
                onTap: () {
                  Navigator.pop(context, category);
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.string(
                        category.iconPath,
                        width: 22,
                        height: 22,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 4),
                      MyText(category.name),
                    ],
                  ),
                ),
              ),
            ),

          // “Add” button
          Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Theme.of(context).appBarTheme.backgroundColor,
              onTap: () {},
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(FontAwesome.plus_circle),
                    SizedBox(height: 4),
                    MyText('Custom'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
