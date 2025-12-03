import 'package:cookmate/data/categories.dart';
import 'package:cookmate/widgets/category_card.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1.1,
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 3,
      ),
      children: categories.map((category) {
        return CategoryCard(category: category);
      }).toList(),
    );
  }
}
