import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:uuid/uuid.dart';

import '../database/database.dart';
import '../models/meal_model.dart';

const uuid = Uuid();

class UserMealsNotifier extends StateNotifier<List<MealModel>> {
  UserMealsNotifier() : super(const []);

  Future<void> loadMeals() async {
    try {
      final db = await getDatabase();
      final data = await db.query('user_meals');

      final meals = data.map((row) {
        return MealModel(
          id: row['id'] as String,
          name: row['name'] as String,
          image: row['image'] as String,
          time: row['time'] as String,
          price: row['price'] as String,
          ingredients: (row['ingredients'] as String).split(','),
          steps: (row['steps'] as String).split(','),
        );
      }).toList();

      state = meals;
    } catch (error) {
      debugPrint('Error loading meals: $error');
    }
  }

  Future<void> addMeal({
    required String name,
    required String image,
    required String time,
    required String price,
    required List<String> ingredients,
    required List<String> steps,
  }) async {
    try {
      String imagePath = image;

      if (!image.startsWith('http')) {
        final imageFile = File(image);
        final appDir = await syspaths.getApplicationDocumentsDirectory();
        final filename = path.basename(imageFile.path);
        final copiedImage = await imageFile.copy('${appDir.path}/$filename');
        imagePath = copiedImage.path;
      }

      final newMeal = MealModel(
        id: uuid.v4(),
        name: name,
        image: imagePath,
        time: time,
        price: price,
        ingredients: ingredients,
        steps: steps,
      );

      final db = await getDatabase();

      await db.insert('user_meals', {
        'id': newMeal.id,
        'name': newMeal.name,
        'image': newMeal.image,
        'time': newMeal.time,
        'price': newMeal.price,
        'ingredients': newMeal.ingredients.join(','),
        'steps': newMeal.steps.join(','),
      });

      state = [newMeal, ...state];
    } catch (error) {
      debugPrint('Error adding meal: $error');
    }
  }

  Future<void> removeMeal(MealModel meal) async {
    try {
      if (!meal.image.startsWith('http')) {
        final imageFile = File(meal.image);
        if (await imageFile.exists()) {
          await imageFile.delete();
        }
      }

      final db = await getDatabase();
      await db.delete('user_meals', where: 'id = ?', whereArgs: [meal.id]);

      state = state.where((m) => m.id != meal.id).toList();
    } catch (error) {
      debugPrint('Error deleting meal: $error');
    }
  }
}

final userMealsProvider =
    StateNotifierProvider<UserMealsNotifier, List<MealModel>>(
      (ref) => UserMealsNotifier(),
    );
