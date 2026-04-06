import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

class EmptyGroceryScreen extends StatelessWidget {
  const EmptyGroceryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.asset('assets/app_assets/empty_list.png'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Groceries Added to the Cart',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              'Please click + button to add groceries',
              textAlign: TextAlign.center,
            ),
            MaterialButton(
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              color: Colors.green,
              onPressed: () {
                Provider.of<TabManager>(context, listen: false).goToRecipes();
              },
              child: const Text('Browse Recipes'),
            ),
          ],
        ),
      ),
    );
  }
}
