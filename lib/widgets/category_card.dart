import 'package:cookmate/models/category_model.dart';
import 'package:cookmate/transition/fade_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

import '../data/meals.dart';
import '../screens/meal_screen.dart';

class CategoryCard extends ConsumerWidget {
  const CategoryCard({super.key, required this.category});
  final CategoryModel category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealsOfCategory = meals
        .where((meal) => meal.id.contains(category.id))
        .toList();
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageFadeTransition(
            page: MealsScreen(
              meals: mealsOfCategory,
              categoryName: category.name,
              categoryColor: category.color!,
              fav: false,
              myCuisine: category.id == '8' ? true : false,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 5),
        clipBehavior: Clip.hardEdge,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Stack(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(category.image),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              imageErrorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 30,
                color: Colors.black.withValues(alpha: 0.5),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  category.name,
                  style: TextTheme.of(
                    context,
                  ).titleMedium?.copyWith(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
