import 'package:flutter/material.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.color,
  });

  final String id;
  final String name;
  final String image;
  final Color? color;
}
