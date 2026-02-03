class Recipe{
  String label;    //non nullable must assign value or use late
  String imageUrl;

  Recipe(
    this.label,
    this.imageUrl,
  );

  //pick images from picksum.photos
  static List<Recipe> samples = [
    Recipe('Spaghetti and Meatballs', 'assets/temp1.png'),
    Recipe('Tomato Soup', 'assets/temp2.png'),
    Recipe('Grilled Cheese', 'assets/temp3.png'),
    Recipe('Chocolate Chip Cookies', 'assets/temp4.png'),
  ];
}