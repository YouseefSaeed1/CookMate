import 'package:flutter/material.dart';

class MealMetadata extends StatelessWidget {
  const MealMetadata({super.key, required this.time, required this.price});

  final String time;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            const Icon(Icons.timelapse, color: Colors.deepOrange),
            const SizedBox(width: 4),
            Text("$time min"),
          ],
        ),
        const SizedBox(width: 20),
        Row(
          children: [
            const Icon(Icons.monetization_on, color: Colors.blueAccent),
            const SizedBox(width: 4),
            Text("$price \$"),
          ],
        ),
      ],
    );
  }
}
