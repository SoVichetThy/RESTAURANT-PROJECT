import 'food_category.dart';
import 'restaurant.dart';

class Menu {
  final String name;
  final FoodCategory category;
  final double price;
  final String? description;
  final List<String> ingredient = [];
  final bool isSpicy;

  Menu({
    required this.name,
    required this.category,
    required this.price,
    required this.isSpicy,
    this.description,
  });
}
