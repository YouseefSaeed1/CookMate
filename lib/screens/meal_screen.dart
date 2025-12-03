import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookmate/models/meal_model.dart';
import 'package:cookmate/transition/fade_transition.dart';
import 'package:cookmate/widgets/meal_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../providers/user_meals_provider.dart';
import '../widgets/back_widget.dart';
import 'add_meal_screen.dart';

class MealsScreen extends ConsumerStatefulWidget {
  const MealsScreen({
    super.key,
    this.meals,
    required this.categoryName,
    required this.categoryColor,
    required this.fav,
    required this.myCuisine,
  });
  final List<MealModel>? meals;
  final String categoryName;
  final Color categoryColor;
  final bool fav;
  final bool myCuisine;

  @override
  ConsumerState<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends ConsumerState<MealsScreen> {
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    if (widget.myCuisine) {
      ref.read(userMealsProvider.notifier).loadMeals();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<MealModel> mealsToDisplay = widget.myCuisine
        ? ref.watch(userMealsProvider)
        : widget.meals!;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            if (!widget.fav)
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 3),
                child: AppBar(
                  leading: BackWidget(),
                  actions: [
                    if (widget.myCuisine)
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            PageFadeTransition(page: const AddMealScreen()),
                          );
                        },
                        icon: const Icon(CupertinoIcons.plus),
                      ),
                  ],
                ),
              ),
            Expanded(
              child: mealsToDisplay.isEmpty
                  ? const Center(
                      child: Text('You haven\'t added any meals here yet!'),
                    )
                  : CarouselSlider.builder(
                      itemCount: mealsToDisplay.length,
                      itemBuilder: (context, index, realIndex) {
                        final meal = mealsToDisplay[index];
                        return MealCard(
                          meal: meal,
                          categoryName: widget.categoryName,
                          categoryColor: widget.categoryColor,
                          isUserMeal: widget.myCuisine,
                        );
                      },
                      options: CarouselOptions(
                        viewportFraction: 1,
                        height: double.infinity,
                        enableInfiniteScroll: mealsToDisplay.length > 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    ),
            ),
            if (mealsToDisplay.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: AnimatedSmoothIndicator(
                  activeIndex: currentIndex,
                  count: mealsToDisplay.length,
                  effect: const JumpingDotEffect(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
