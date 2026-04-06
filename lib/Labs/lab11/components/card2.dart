import 'package:flutter/material.dart';

import '../fooderlich_theme.dart';
import '../models/models.dart';
import 'author_card.dart';

class Card2 extends StatelessWidget {
  final ExploreRecipe recipe;
  final double width;
  final double height;

  const Card2({
    super.key,
    required this.recipe,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
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
        child: Column(
          children: [
            AuthorCard(
              authorName: recipe.authorName,
              title: recipe.role,
              imageProvider: AssetImage(recipe.profileImage),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Text(
                      recipe.title,
                      style: FooderlichTheme.lightTextTheme.bodyLarge,
                    ),
                  ),
                  Positioned(
                    bottom: 70,
                    left: 16,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        recipe.subtitle,
                        style: FooderlichTheme.lightTextTheme.bodyLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
