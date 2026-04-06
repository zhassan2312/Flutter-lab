import 'package:flutter/material.dart';
import '../components/components.dart';
import '../models/models.dart';

class TodayRecipeListView extends StatelessWidget {
  final List<ExploreRecipe> recipes;

  const TodayRecipeListView({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = (screenSize.width * 0.76).clamp(260.0, 380.0);
    final cardHeight = (screenSize.height * 0.62).clamp(320.0, 460.0);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recipes of the day'),
          const SizedBox(height: 16),
          SizedBox(
            height: cardHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return buildCard(recipe, cardWidth, cardHeight);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(width: 16);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(ExploreRecipe recipe, double width, double height) {
    if (recipe.cardType == RecipeCardType.card1) {
      return Card1(recipe: recipe, width: width, height: height);
    } else if (recipe.cardType == RecipeCardType.card2) {
      return Card2(recipe: recipe, width: width, height: height);
    } else if (recipe.cardType == RecipeCardType.card3) {
      return Card3(recipe: recipe, width: width, height: height);
    } else {
      throw Exception('This Card do not exist yet');
    }
  }
}
