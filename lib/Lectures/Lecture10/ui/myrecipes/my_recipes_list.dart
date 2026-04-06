import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyRecipesList extends StatefulWidget {
  const MyRecipesList({super.key});

  @override
  State<MyRecipesList> createState() => _MyRecipesListState();
}

class _MyRecipesListState extends State<MyRecipesList> {
  List<String> recipes = <String>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildRecipeList(context),
    );
  }

  Widget _buildRecipeList(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 100,
          child: Slidable(
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  label: 'Delete',
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  icon: Icons.delete,
                  onPressed: (context) {},
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  label: 'Delete',
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  icon: Icons.delete,
                  onPressed: (context) {},
                ),
              ],
            ),
            child: Card(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.white,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.asset(
                      'assets/temp1.png',
                      height: 56,
                      width: 56,
                      fit: BoxFit.cover,
                    ),
                    title: const Text('Chicken Vesuvio'),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}