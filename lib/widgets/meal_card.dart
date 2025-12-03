import 'dart:io';

import 'package:cookmate/models/meal_model.dart';
import 'package:cookmate/screens/meal_details_screen.dart';
import 'package:cookmate/transition/fade_transition.dart';
import 'package:cookmate/widgets/meal_metadata.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'meal_flag.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.meal,
    required this.categoryName,
    required this.categoryColor,
    this.isUserMeal = false,
  });
  final MealModel meal;
  final String categoryName;
  final Color categoryColor;
  final bool isUserMeal;

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (meal.image.startsWith('http')) {
      imageProvider = NetworkImage(meal.image);
    } else {
      imageProvider = FileImage(File(meal.image));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Hero(
              tag: meal.id,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: imageProvider,
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
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (categoryName.isNotEmpty && !isUserMeal)
                        MealFlag(country: categoryName),
                      const SizedBox(width: 6),
                      Text(
                        categoryName,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: categoryColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    meal.name,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontSize: 30),
                    softWrap: true,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  MealMetadata(time: meal.time, price: meal.price),
                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageFadeTransition(
                          page: MealDetailsScreen(
                            meal: meal,
                            isUserMeal: isUserMeal,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF87315),
                      padding: const EdgeInsets.all(10),
                    ),
                    label: Text(
                      'See Details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    icon: const Icon(
                      Icons.arrow_right_alt,
                      color: Colors.white,
                      size: 25,
                    ),
                    iconAlignment: IconAlignment.end,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
