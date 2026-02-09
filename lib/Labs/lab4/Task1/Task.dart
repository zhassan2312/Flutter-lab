import 'package:flutter/material.dart';
import 'package:flutter_lab/Labs/lab4/Task1/component/recipeDetails.dart';
import 'package:flutter_lab/Labs/lab4/Task1/model/recipe.dart';

void main() {
  runApp(const RecipeList());
}

class RecipeList extends StatelessWidget {
  const RecipeList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        
      ),
      home: const MyHomePage(title: 'Recipe`s List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,textAlign:TextAlign.center,style:TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrange,
        leading:PopupMenuButton(itemBuilder: (context) =>[
          for (Recipe recipe in Recipe.samples) PopupMenuItem(
            value: recipe,
            child: Text(recipe.label),
            onTap: () {
              Navigator.push
              (
                context, 
                PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
                    return RecipeDetail(recipe: recipe);
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);  // Start from right (x=1.0)
                    const end = Offset.zero;          // End at center (x=0.0)
                    const curve = Curves.ease;        // Smooth easing curve
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                )
              );
            }
          )
        ],
        icon: const Icon(Icons.menu,color: Colors.white,),)
      ),
      body: Column(  // Column to stack the title text and the grid vertically
          children: 
          [
            Padding(  // Padding adds space around the text for better visual separation from edges
              padding: EdgeInsets.all(12),
              child: Text(
                "Choose Any one Recipe to see details",
                textAlign: TextAlign.left,  // Aligns text to the left
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(  // Expanded makes the GridView fill the remaining vertical space in the Column, allowing it to scroll if content exceeds screen height
              child: GridView.builder( // GridView.builder creates a scrollable grid of items, efficient for large lists
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(  // Defines grid layout: 3 columns, with spacing between rows
                  crossAxisCount: 3,
                  mainAxisSpacing: 0.75,  // Space between rows (in logical pixels)
                ),
                itemCount: Recipe.samples.length,  // Number of items based on recipe list
                itemBuilder: (BuildContext context, int index) {  // Builds each grid item
                  return GestureDetector(  // GestureDetector detects taps to navigate to recipe details
                    onTap: () {
                      Navigator.push
                      (
                        context, 
                        PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
                            return RecipeDetail(recipe: Recipe.samples[index]);
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);  // Start from right (x=1.0)
                            const end = Offset.zero;          // End at center (x=0.0)
                            const curve = Curves.ease;        // Smooth easing curve
                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        )
                      );
                    },
                    child: buildRecipeCard(Recipe.samples[index]),  // Calls helper method to build the card
                  );
                },
              )
            )
        ]
      )
    );
  }

  Widget buildRecipeCard(Recipe recipe) {  // Helper method to build a card for each recipe
    return InkWell(  // InkWell provides hover and tap effects
    hoverColor: Colors.grey[800],  // Light grey background on hover
    child:Card(  // Card provides a material design container with elevation
      child: Column(  // Column stacks image and text vertically inside the card
        children: <Widget>[
          Expanded(  // Expanded makes the image fill the available height in the card, scaling proportionally
            child: Image.asset(recipe.imageUrl, fit: BoxFit.contain,),  // fit: BoxFit.contain ensures image fits without cropping
          ),
          Padding(  // Padding adds space around the text inside the card
            padding: const EdgeInsets.all(8.0),
            child: Text(
              recipe.label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10,),  // SizedBox adds fixed vertical space at the bottom
        ],
      ),
    ),
    );
  }
}
