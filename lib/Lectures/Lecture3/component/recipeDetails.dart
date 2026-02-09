import 'package:flutter/material.dart';
import '../model/recipe.dart';

class RecipeDetail extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetail({super.key, required this.recipe});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();

}

class _RecipeDetailState extends State<RecipeDetail> {
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text(widget.recipe.label),),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 300,width: double.infinity,child: Image(image: AssetImage(widget.recipe.imageUrl)),),
            SizedBox(height: 5,),
            Text(widget.recipe.label)
          ]
          ,),)
      ,
    );
  }
}