class Recipe {
  String label;
  String imageUrl;
  int servings;
  List<Ingredient> ingredients;
  Recipe(this.label,this.imageUrl,this.servings,this.ingredients);
  static List<Recipe> samples=[
    Recipe("Spagheti and MeatBalls", 'assets/temp1.png',2,[
      Ingredient('Spaghetti', 'packet', 1),
      Ingredient('Salt', 'Spoon', 2),
      Ingredient('Sauce', 'ml', 50),

    ]),
    Recipe('Tomato Soup', 'assets/temp2.png',4,[
      Ingredient('Tomatoes', 'kg', 1),
      Ingredient('Salt', 'Spoon', 2),
      Ingredient('Water', 'ml', 500),
    ]),
    Recipe('Chicken Cheese Sandwich', 'assets/temp3.png',6,[
      Ingredient('Chicken', 'kg', 1),
      Ingredient('Cheese', 'Spoon', 2),
      Ingredient('Bread', 'slice', 2),
    ]),
    Recipe('Cookies', 'assets/temp4.png', 1, [
      Ingredient('Flour', 'cup', 2),
      Ingredient('Sugar', 'cup', 1),
      Ingredient('Butter', 'tbsp', 3),
    ]),
  ];
}

class Ingredient{
  String name;
  String measure;
  double quantity;
  Ingredient(this.name,this.measure,this.quantity);
}
