class Recipe {
  final String label;
  final String imageUrl;
  final int servings;
  final String prepTime;          // Prep time string e.g. "20 min"
  final List<Ingredient> ingredients;
  final List<RecipeComment> comments;

  Recipe(this.label, this.imageUrl, this.servings, this.prepTime,
      this.ingredients, this.comments);

  static List<Recipe> samples = [
    Recipe(
      'Spaghetti and Meatballs',
      'assets/temp1.png',
      2,
      '25 min',
      [
        Ingredient('Spaghetti', 'packet', 1),
        Ingredient('Salt', 'spoon', 2),
        Ingredient('Tomato Sauce', 'ml', 50),
      ],
      [
        RecipeComment('Ali Hassan', 'Absolutely delicious! Made it for dinner.', '2 hrs ago'),
        RecipeComment('Sara Khan', 'Added extra cheese — even better!', '5 hrs ago'),
        RecipeComment('Omar Malik', 'Quick and easy weeknight meal.', 'Yesterday'),
      ],
    ),
    Recipe(
      'Tomato Soup',
      'assets/temp2.png',
      4,
      '15 min',
      [
        Ingredient('Tomatoes', 'kg', 1),
        Ingredient('Salt', 'spoon', 2),
        Ingredient('Water', 'ml', 500),
      ],
      [
        RecipeComment('Fatima R.', 'So warm and comforting on a cold day.', '1 hr ago'),
        RecipeComment('Bilal A.', 'I blended it smooth — came out great!', '3 hrs ago'),
      ],
    ),
    Recipe(
      'Chicken Cheese Sandwich',
      'assets/temp3.png',
      6,
      '10 min',
      [
        Ingredient('Chicken', 'kg', 1),
        Ingredient('Cheese', 'slices', 2),
        Ingredient('Bread', 'slices', 2),
      ],
      [
        RecipeComment('Zara N.', 'Kids loved it! Perfect lunchbox idea.', '30 min ago'),
        RecipeComment('Hamza T.', 'Toasted it — crispy and cheesy perfection.', '4 hrs ago'),
        RecipeComment('Nadia S.', 'Added jalapeños for a kick!', '6 hrs ago'),
      ],
    ),
    Recipe(
      'Cookies',
      'assets/temp4.png',
      1,
      '30 min',
      [
        Ingredient('Flour', 'cup', 2),
        Ingredient('Sugar', 'cup', 1),
        Ingredient('Butter', 'tbsp', 3),
      ],
      [
        RecipeComment('Anum Z.', 'Turned out soft and chewy — perfect!', '2 days ago'),
        RecipeComment('Kamran B.', 'Doubled the sugar — very sweet treat.', '3 days ago'),
      ],
    ),
  ];
}

class Ingredient {
  final String name;
  final String measure;
  final double quantity;
  Ingredient(this.name, this.measure, this.quantity);
}

class RecipeComment {
  final String author;
  final String text;
  final String timestamp;
  RecipeComment(this.author, this.text, this.timestamp);
}
