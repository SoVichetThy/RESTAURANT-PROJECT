import '../enum/food_category.dart';

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

  @override
  String toString() {
    return 'Menu(name: $name, category: $category, price: $price, description: $description, ingredient: $ingredient, isSpicy: $isSpicy)';
  }
}
