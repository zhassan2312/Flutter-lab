import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../components/components.dart';
import '../api/mock_fooderlich_service.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final MockFooderlichService exploreService = MockFooderlichService();
  late Future<List<SimpleRecipe>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _recipesFuture = exploreService.getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeSearchManager>(
      builder: (context, searchManager, _) {
        return FutureBuilder<List<SimpleRecipe>>(
          future: _recipesFuture,
          builder: (context, AsyncSnapshot<List<SimpleRecipe>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final recipes = snapshot.data ?? <SimpleRecipe>[];
              final filteredRecipes = recipes.where((recipe) {
                if (searchManager.query.isEmpty) {
                  return true;
                }

                final searchableText = [
                  recipe.title,
                  recipe.source,
                  recipe.duration,
                  ...recipe.information,
                ].join(' ').toLowerCase();

                return searchableText.contains(searchManager.query);
              }).toList();

              if (filteredRecipes.isEmpty) {
                return const Center(child: Text('No recipes match your search.'));
              }

              return RecipesGridView(recipes: filteredRecipes);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}
