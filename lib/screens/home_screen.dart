import 'package:cookmate/providers/favourite_provider.dart';
import 'package:cookmate/screens/categories_screen.dart';
import 'package:cookmate/screens/meal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    ref.read(favoriteMealsProvider.notifier).loadFavorites();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidget = CategoriesScreen();
    String title = 'Cuisines';

    if (_selectedIndex == 1) {
      final favouriteMeals = ref.watch(favoriteMealsProvider);

      currentWidget = favouriteMeals.isNotEmpty
          ? MealsScreen(
              meals: favouriteMeals,
              categoryName: '',
              categoryColor: Colors.grey,
              fav: true,
              myCuisine: false,
            )
          : Center(
              child: Text(
                'You have no favorite meals yet. Add some! 😋',
                textAlign: TextAlign.center,
              ),
            );
      title = 'Favourites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextTheme.of(context).titleMedium),
      ),
      body: currentWidget,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.fastfood),
              label: 'Cuisines',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favourite',
            ),
          ],
        ),
      ),
    );
  }
}
