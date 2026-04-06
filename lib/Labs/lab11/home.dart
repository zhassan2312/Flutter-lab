import 'package:flutter/material.dart';
import 'models/models.dart';
import 'screens/explore_screen.dart';
import 'screens/recipes_screen.dart';
import 'screens/grocery_screen.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final TextEditingController _homeSearchController = TextEditingController();

  static List<Widget> pages = <Widget>[
    ExploreScreen(),
    const RecipesScreen(),
    GroceryScreen(),
  ];

  @override
  void dispose() {
    _homeSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TabManager, RecipeSearchManager>(
      builder: (context, tabManager, searchManager, child) {
        if (_homeSearchController.text != searchManager.query) {
          _homeSearchController.value = TextEditingValue(
            text: searchManager.query,
            selection:
                TextSelection.collapsed(offset: searchManager.query.length),
          );
        }

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 74,
            title: tabManager.selectedTab == 1
                ? TextField(
                    controller: _homeSearchController,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) => searchManager.setQuery(value),
                    style: Theme.of(context).textTheme.titleMedium,
                    decoration: InputDecoration(
                      hintText: 'Search recipes from home...',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.black54),
                      prefixIcon: const Icon(Icons.search, size: 22),
                      suffixIcon: searchManager.query.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => searchManager.clear(),
                            ),
                      isDense: true,
                    ),
                  )
                : Text(
                    'Recipe App',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
          ),
          body: IndexedStack(index: tabManager.selectedTab, children: pages),
          //body: pages[tabManager.selectedTab],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabManager.selectedTab,
            onTap: (index) {
              tabManager.goToTab(index);
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Explore',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Recipes'),
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'To Buy'),
            ],
          ),
        );
      },
    );
  }
}
