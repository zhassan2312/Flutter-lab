import 'package:flutter/material.dart';
import '../model/recipe.dart';

class RecipeDetail extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetail({super.key, required this.recipe});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  
  int _sliderVal = 1;  // State variable to track the slider value for servings multiplier

  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Scaffold provides the basic material design layout structure
      appBar: AppBar(  // AppBar displays the recipe title at the top
        title: Text(widget.recipe.label, textAlign: TextAlign.center),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        leading: IconButton(  // IconButton to navigate back to the previous screen
          icon: const Icon(Icons.arrow_back, color: Colors.white),  // Back arrow icon
          onPressed: () {
            Navigator.pop(context);  // Pops the current route off the navigator stack
          },
        ),
      ),
      body: Center(  // Center centers the entire column vertically and horizontally on the screen
        child: Column(  // Column stacks widgets vertically
          children: <Widget>[
            Image.asset(  // Displays the recipe image with fixed dimensions
              widget.recipe.imageUrl,
              height: 300,
              width: 300,
            ),
            const SizedBox(height: 20),  // SizedBox adds fixed vertical spacing
            Text(  // Displays the recipe label with bold styling
              widget.recipe.label,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(  // Expanded makes the ListView fill the remaining vertical space
              child: ListView.builder(  // ListView.builder efficiently builds a list of ingredients
                shrinkWrap: true,
                itemCount: widget.recipe.ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = widget.recipe.ingredients[index];
                  return Text(  // Displays each ingredient with quantity adjusted by slider
                    '${_sliderVal * ingredient.quantity} ${ingredient.measure} ${ingredient.name}',
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
            Slider(  // Slider allows adjusting servings
              min: 1,
              max: 10,
              divisions: 9,
              value: _sliderVal.toDouble(),
              activeColor: Colors.deepOrange,
              label: '${_sliderVal * widget.recipe.servings} servings',
              onChanged: (value) {
                setState(() {
                  _sliderVal = value.toInt();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
