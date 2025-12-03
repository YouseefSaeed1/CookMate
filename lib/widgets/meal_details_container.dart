import 'package:flutter/material.dart';

class MealDetailsContainer extends StatelessWidget {
  const MealDetailsContainer({super.key, required this.mealDetails});
  final Widget mealDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff25262A), Color(0xff1B1A1D)],
          begin: AlignmentGeometry.topLeft,
          end: AlignmentGeometry.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: mealDetails,
    );
  }
}
