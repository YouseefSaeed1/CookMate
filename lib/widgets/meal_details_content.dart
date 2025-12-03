import 'package:cookmate/providers/favourite_provider.dart';
import 'package:cookmate/providers/user_meals_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/meal_model.dart';

class MealDetailsContent extends ConsumerStatefulWidget {
  const MealDetailsContent({
    super.key,
    required this.meal,
    required this.isUserMeal,
  });

  final MealModel meal;
  final bool isUserMeal;

  @override
  ConsumerState<MealDetailsContent> createState() => _MealDetailsContentState();
}

class _MealDetailsContentState extends ConsumerState<MealDetailsContent> {
  bool _isShowingSteps = false;

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Meal'),
        content: const Text('Are you sure you want to delete this meal?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              ref.read(userMealsProvider.notifier).removeMeal(widget.meal);
              Navigator.of(ctx).pop();

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMeals = ref.watch(favoriteMealsProvider);
    final isFavourite = favoriteMeals.contains(widget.meal);
    final listData = _isShowingSteps
        ? widget.meal.steps
        : widget.meal.ingredients;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff25262A), Color(0xff1B1A1D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.meal.name,
                  style: Theme.of(context).textTheme.titleLarge,
                  softWrap: true,
                ),
              ),
              if (widget.isUserMeal)
                IconButton(
                  onPressed: _showDeleteConfirmationDialog,
                  icon: const Icon(CupertinoIcons.delete, color: Colors.red),
                )
              else
                IconButton(
                  onPressed: () {
                    ref
                        .read(favoriteMealsProvider.notifier)
                        .toggleFavorite(widget.meal);
                  },
                  icon: Icon(
                    isFavourite
                        ? CupertinoIcons.suit_heart_fill
                        : CupertinoIcons.suit_heart,
                    key: ValueKey(isFavourite),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '${widget.meal.time} min',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                '${widget.meal.price} \$',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xff25262A),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isShowingSteps = false;
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: _isShowingSteps
                        ? Colors.transparent
                        : const Color(0xff383C41),
                  ),
                  child: const Text(
                    'Ingredients',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isShowingSteps = true;
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: _isShowingSteps
                        ? const Color(0xff383C41)
                        : Colors.transparent,
                  ),
                  child: const Text(
                    'Steps',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: listData.length,
              itemBuilder: (context, index) {
                final detail = listData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isShowingSteps)
                        Text(
                          '${index + 1}. ',
                          style: const TextStyle(
                            color: Color(0xffBBBBBB),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          detail,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
