import 'package:flutter/material.dart';
import '../components/components.dart';
import '../models/models.dart';

class RecipesGridView extends StatelessWidget {
  final List<SimpleRecipe> recipes;

  const RecipesGridView({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 1000 ? 4 : (width >= 700 ? 3 : 2);

        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: GridView.builder(
            itemCount: recipes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final simpleRecipe = recipes[index];
              return RecipeThumbnail(recipe: simpleRecipe);
            },
          ),
        );
      },
    );
  }
}
