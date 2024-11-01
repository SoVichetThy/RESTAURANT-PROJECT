enum FoodCategory {
  food_category("Food"),
  drinks_category("Drinks"),
  dessert_category("Dessert");

  final String categoryLabel;

  const FoodCategory(this.categoryLabel);

  String toString() {
    return switch (this) {
      FoodCategory.food_category => categoryLabel,
      FoodCategory.drinks_category => categoryLabel,
      FoodCategory.dessert_category => categoryLabel
    };
  }
}
