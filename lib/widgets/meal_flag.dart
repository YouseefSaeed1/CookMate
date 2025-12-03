import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

const Map<String, String> _countryCodeMap = {
  'Italian Cuisine': 'it',
  'Japanese Cuisine': 'jp',
  'Mexican Cuisine': 'mx',
  'German Cuisine': 'de',
  'Indian Cuisine': 'in',
  'American Cuisine': 'us',
  'Egyptian Cuisine': 'eg',
};

class MealFlag extends StatelessWidget {
  const MealFlag({super.key, required this.country});

  final String country;

  @override
  Widget build(BuildContext context) {
    final String? countryCode = _countryCodeMap[country];

    return CountryFlag.fromCountryCode(
      countryCode!,
      theme: ImageTheme(shape: RoundedRectangle(5), width: 25, height: 20),
    );
  }
}
