import 'package:flutter/material.dart';
import 'package:flutter_lab/Labs/lab5/Task1/component/recipeDetails.dart';
import 'package:flutter_lab/Labs/lab5/Task1/model/recipe.dart';

void main() {
  runApp(const RecipeList());
}

// RecipeList is StatefulWidget to hold the theme mode state
class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  
  bool _isDarkMode = false;  // State variable to track current theme mode

  // Callback to toggle between light and dark themes
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      // Switch between light and dark themes based on _isDarkMode flag
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[850],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,  // Controlled by state
      home: MyHomePage(title: 'Recipe\'s List', onToggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.onToggleTheme,  // Callback to toggle theme
    required this.isDarkMode,     // Current theme mode flag
  });

  final String title;
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        // Toggle theme button in the AppBar
        actions: [
          IconButton(
            tooltip: widget.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,  // Icon changes based on mode
              color: Colors.white,
            ),
            onPressed: widget.onToggleTheme,  // Triggers theme toggle on tap
          ),
        ],
        leading: PopupMenuButton(
          itemBuilder: (context) => [
            for (Recipe recipe in Recipe.samples) PopupMenuItem(
              value: recipe,
              child: Text(recipe.label),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return RecipeDetail(recipe: recipe);
                    },
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);  // Start from right
                      const end = Offset.zero;          // End at center
                      const curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
            )
          ],
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
      ),
      body: Column(  // Column to stack the title text and the grid vertically
        children: [
          Padding(  // Padding adds space around the text
            padding: const EdgeInsets.all(12),
            child: Text(
              "Choose Any one Recipe to see details",
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(  // Expanded makes the GridView fill the remaining vertical space
            child: GridView.builder(  // GridView.builder creates a scrollable grid
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(  // 3-column grid
                crossAxisCount: 3,
                mainAxisSpacing: 0.75,
              ),
              itemCount: Recipe.samples.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(  // GestureDetector detects taps
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return RecipeDetail(recipe: Recipe.samples[index]);
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;
                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: buildRecipeCard(Recipe.samples[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRecipeCard(Recipe recipe) {  // Helper method to build a card for each recipe
    return InkWell(
      hoverColor: Colors.grey[800],
      child: Card(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Image.asset(recipe.imageUrl, fit: BoxFit.contain),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                recipe.label,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
