import 'dart:io';

import 'package:cookmate/models/meal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

import '../widgets/back_widget.dart';
import '../widgets/meal_details_content.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
    this.isUserMeal = false,
  });

  final MealModel meal;
  final bool isUserMeal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ImageProvider imageProvider;
    if (meal.image.startsWith('http')) {
      imageProvider = NetworkImage(meal.image);
    } else {
      imageProvider = FileImage(File(meal.image));
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 3),
            child: AppBar(leading: BackWidget()),
          ),
          Expanded(
            child: Hero(
              tag: meal.id,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: imageProvider,
                fit: BoxFit.contain,
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
            child: MealDetailsContent(meal: meal, isUserMeal: isUserMeal),
          ),
        ],
      ),
    );
  }
}
