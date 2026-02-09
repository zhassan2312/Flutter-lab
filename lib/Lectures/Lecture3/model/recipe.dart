class Recipe {
  String label;
  String imageUrl;
  int servings;
  List<Ingredient> ingredients;
  Recipe(this.label,this.imageUrl,this.servings,this.ingredients);
  static List<Recipe> samples=[
    Recipe("Spagheti and MeatBalls", '../assets/temp1.jpg',2,[
      Ingredient('Spaghetti', 'packet', 1),
      Ingredient('Salt', 'Spoon', 2),
      Ingredient('Sauce', 'ml', 50),

    ]),
    Recipe('Chicken Karahi', '../assets/temp2.jpg',4,[
      Ingredient('Chicken', 'kg', 1),
      Ingredient('Salt', 'Spoon', 2),
      Ingredient('Spices', 'g', 50),
    ]),
    Recipe('Chapal Kebab', '../assets/temp3.jpg',6,[
      Ingredient('Beef', 'kg', 1),
      Ingredient('Salt', 'Spoon', 2),
      Ingredient('Spices', 'g', 50),
    ]),
    Recipe('Beef grill burger', '../assets/temp4.jpg', 1, [
      Ingredient('Beef', 'kg', 1),
      Ingredient('Salt', 'Spoon', 2),
      Ingredient('Spices', 'g', 50),
    ]),
  ];
}



class Ingredient{
  String name;
  String measure;
  double quantity;
  Ingredient(this.name,this.measure,this.quantity);
}