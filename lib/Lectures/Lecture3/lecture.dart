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
      home: const MyHomePage(title: 'RecipeList'),
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
        title: Text(widget.title),
        backgroundColor: Colors.green,
      ),
      body:Center(
        child: ListView.builder( //it adds expanded auto increase in length
          itemCount: Recipe.samples.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RecipeDetail(recipe: Recipe.samples[index],);
                }));
              },
              child: buildRecipeCard(Recipe.samples[index]),
            );
          },
        ),
      )
    );
  }

  Widget buildRecipeCard(Recipe recipe) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(recipe.imageUrl, fit: BoxFit.contain,),
          Text(
            recipe.label,
          ),
        ],
      ),
    );
  }
}
