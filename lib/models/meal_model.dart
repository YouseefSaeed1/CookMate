class MealModel {
  const MealModel({
    required this.id,
    required this.name,
    required this.image,
    required this.time,
    required this.price,
    required this.ingredients,
    required this.steps,
  });

  final String id;
  final String name;
  final String image;
  final String price;
  final String time;
  final List<String> ingredients;
  final List<String> steps;
}
