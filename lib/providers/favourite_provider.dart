import 'package:cookmate/data/meals.dart';
import 'package:cookmate/models/meal_model.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../database/database.dart';

class FavoriteMealsNotifier extends StateNotifier<List<MealModel>> {
  FavoriteMealsNotifier() : super(const []);

  Future<void> loadFavorites() async {
    final db = await getDatabase();
    final data = await db.query('favorite_meals');

    final favIds = data.map((row) => row['id'] as String).toList();
    state = meals.where((meal) => favIds.contains(meal.name)).toList();
  }

  Future<void> toggleFavorite(MealModel meal) async {
    //loadFavorites();
    final db = await getDatabase();

    final isFav = state.contains(meal);

    if (isFav) {
      // remove
      await db.delete(
        'favorite_meals',
        where: 'id = ?',
        whereArgs: [meal.name],
      );

      state = state.where((x) => x != meal).toList();
    } else {
      // add
      await db.insert('favorite_meals', {'id': meal.name});

      state = [...state, meal];
    }
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<MealModel>>(
      (ref) => FavoriteMealsNotifier(),
    );
