import 'package:flutter/material.dart';
import '../fooderlich_theme.dart';
import '../models/models.dart';

class Card1 extends StatelessWidget {
  final ExploreRecipe recipe;
  final double width;
  final double height;

  const Card1({
    super.key,
    required this.recipe,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints.tightFor(
          width: width,
          height: height,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(recipe.backgroundImage),
            fit: BoxFit.cover,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Stack(
          children: [
            Text(
              recipe.subtitle,
              style: FooderlichTheme.darkTextTheme.bodySmall,
            ),
            Positioned(
              top: 20,
              child: Text(
                recipe.title,
                style: FooderlichTheme.darkTextTheme.bodyMedium,
              ),
            ),
            Positioned(
              bottom: 30,
              right: 0,
              child: Text(
                recipe.message,
                style: FooderlichTheme.darkTextTheme.bodySmall,
              ),
            ),
            Positioned(
              bottom: 10,
              right: 0,
              child: Text(
                recipe.authorName,
                style: FooderlichTheme.darkTextTheme.bodySmall,
              ),
            )
          ],
        ),
      ),
    );
  }
}
