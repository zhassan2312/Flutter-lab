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
      appBar: AppBar(  // AppBar with back button
        backgroundColor: Colors.deepOrange,
        leading: IconButton(  // IconButton to navigate back to the previous screen
          icon: const Icon(Icons.arrow_back, color: Colors.white),  // Back arrow icon
          onPressed: () {
            Navigator.pop(context);  // Pops the current route off the navigator stack, returning to the previous screen
          },
        ),
      ),
      body: Column(  // Column stacks widgets vertically
        children: <Widget>[
          // Header Stack
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(  // Background image
                  widget.recipe.imageUrl,
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                ),
                Positioned(  // Semi-transparent favorite icon top-right
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: () {
                        // Handle favorite action
                      },
                    ),
                  ),
                ),
                Positioned(  // Overlay container with dark gradient for title
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Text(
                      widget.recipe.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(  // Prep Time badge overlapping bottom
                  bottom: -18,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text(
                          '30 min',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),  // Space after header
          Expanded(  // Expanded makes the ListView fill the remaining vertical space, allowing scrolling if needed
            child: ListView.builder(  // ListView.builder efficiently builds a list of ingredients
              shrinkWrap: true,  // shrinkWrap sizes the list to its content, preventing unnecessary scrolling
              itemCount: widget.recipe.ingredients.length,  // Number of ingredients to display
              itemBuilder: (context, index) {
                final ingredient = widget.recipe.ingredients[index];
                return Text(  // Displays each ingredient with quantity adjusted by slider
                  '${_sliderVal * ingredient.quantity} ${ingredient.measure} ${ingredient.name}',
                  textAlign: TextAlign.center,  // Centers the text horizontally
                );
              },
            ),
          ),
          Slider(  // Slider allows adjusting servings, updating ingredient quantities
            min: 1,  // Minimum value
            max: 10,  // Maximum value
            divisions: 9,  // Number of discrete steps
            value: _sliderVal.toDouble(),  // Current value from state
            activeColor: Colors.deepOrange,  // Color of the active track
            inactiveColor: Colors.black,  // Color of the inactive track
            label: '${_sliderVal * widget.recipe.servings} servings',  // Label showing calculated servings
            onChanged: (value) {  // Callback when slider value changes
              setState(() {  // Updates state to trigger rebuild
                _sliderVal = value.toInt();
              });
            },
          ),
        ],
      ),
    );
  }
}