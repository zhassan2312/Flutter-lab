# Flutter Exam Study Guide — Labs 1–7

---

## LAB 1 — Introduction to Flutter & `StatefulWidget`

### What is a `StatefulWidget`?

A `StatefulWidget` has **mutable state** — it can rebuild itself when data changes.  
A `StatelessWidget` has **no state** — it always renders the same output for the same input.

### Counter App (Lab 1 Task 3)

Key concepts: `setState`, `FloatingActionButton`, re-rendering.

```dart
class _MyHomePageState extends State<MyHomePage> {

  int _counter = 0; // mutable state

  void _incrementCounter() {
    setState(() {       // tells Flutter to rebuild the widget
      _counter++;       // update the state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '$_counter',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,  // calls setState on tap
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

**Rule:** Always change state inside `setState(() { ... })` — without it the widget will NOT rebuild.

---

## LAB 2 — Basic Layout Widgets

### Task 3 — Social Profile Card

Key widgets: `CircleAvatar`, `NetworkImage`, `Column`, `Row`, `TextButton`.

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: Colors.yellowAccent,
  ),
  width: 400,
  height: 400,
  alignment: Alignment.center,
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: 100,
        backgroundImage: NetworkImage('https://example.com/avatar.png'),
      ),
      Text('Zohaib Hassan', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      Text('zhassan@student.nust.edu.pk', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(onPressed: _follow, child: Text('Follow')),
          TextButton(onPressed: _message, child: Text('Message')),
        ],
      ),
    ],
  ),
)
```

### Task 4 — 30/70 Split Layout with `Expanded` + `BottomAppBar`

`Expanded` with `flex` divides available space proportionally.

```dart
Row(children: [
  Expanded(
    flex: 3,           // takes 30% of width
    child: Container(color: Colors.grey[300]),
  ),
  Expanded(
    flex: 7,           // takes 70% of width
    child: Container(color: Colors.grey[500]),
  ),
])

// Plus a bottom bar:
bottomNavigationBar: BottomAppBar(
  color: Colors.deepPurple,
  child: Container(height: 50.0),
),
```

### Task 5 — Student Info Card (`StatelessWidget`)

```dart
class BusinessCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: Zohaib Hassan', style: TextStyle(fontSize: 20)),
            Text('Registration Number: 412221', style: TextStyle(fontSize: 20)),
            Text('Department: Computer Engineering', style: TextStyle(fontSize: 20)),
            Text('Contact: +92 311 6699726', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
```

**`StatelessWidget` vs `StatefulWidget`:**

| | `StatelessWidget` | `StatefulWidget` |
|---|---|---|
| Can change over time? | ❌ No | ✅ Yes |
| Has `setState`? | ❌ No | ✅ Yes |
| Use when | Data never changes | Data can change |

---

## LAB 3 — Navigation, GridView & Complex Layouts

### Task 2 — Digital Business Card

Key widgets: `Card`, `CircleAvatar` (with initials), `Divider`, `Row` of `IconButton`s.

```dart
Card(
  elevation: 8.0,
  margin: EdgeInsets.all(16.0),
  child: Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,  // shrink to fit content
      children: [
        CircleAvatar(
          radius: 50.0,
          backgroundColor: Colors.blue,
          child: Text('JD', style: TextStyle(fontSize: 24, color: Colors.white)),
        ),
        Text('John Doe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text('Software Engineer', style: TextStyle(fontSize: 16, color: Colors.grey)),
        Divider(thickness: 1.0, color: Colors.grey),   // horizontal line separator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: Icon(Icons.phone), onPressed: () {}),
            IconButton(icon: Icon(Icons.email), onPressed: () {}),
            IconButton(icon: Icon(Icons.business), onPressed: () {}),
          ],
        ),
      ],
    ),
  ),
)
```

### Task 3 — Recipe App with `GridView.builder` + `PopupMenuButton` + `SlideTransition`

#### `GridView.builder`

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,        // 3 columns
    mainAxisSpacing: 0.75,    // space between rows
  ),
  itemCount: Recipe.samples.length,
  itemBuilder: (BuildContext context, int index) {
    return GestureDetector(
      onTap: () { /* navigate */ },
      child: Image.asset(Recipe.samples[index].imageUrl, fit: BoxFit.cover),
    );
  },
)
```

#### `PopupMenuButton` in AppBar

```dart
AppBar(
  leading: PopupMenuButton(
    icon: Icon(Icons.menu, color: Colors.white),
    itemBuilder: (context) => [
      for (Recipe recipe in Recipe.samples)
        PopupMenuItem(
          value: recipe,
          child: Text(recipe.label),
          onTap: () { Navigator.push(context, ...); },
        )
    ],
  ),
)
```

#### `PageRouteBuilder` + `SlideTransition` (animated navigation)

```dart
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return RecipeDetail(recipe: recipe); // destination page
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // start from right
      const end = Offset.zero;         // end at center
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  ),
);
```

### Task 4 — Responsive Horizontal Status Bar

Key widgets: `SingleChildScrollView`, `Row`, fixed `Container`, `BottomAppBar`.

```dart
SingleChildScrollView(
  scrollDirection: Axis.horizontal,  // scroll left-right
  child: Row(
    children: [
      Container(width: 120, height: 80, color: Colors.red,
        child: Text('Fixed 120px')),
      SizedBox(width: 8),
      Container(width: 300, height: 80, color: Colors.green,
        child: Text('Flex 2 - 300px')),
      SizedBox(width: 8),
      Container(width: 150, height: 80, color: Colors.blue,
        child: Text('Flex 1 - 150px')),
    ],
  ),
)
```

---

## LAB 4 — Advanced Layouts: Stack, Positioned & Slider

### Task 1 — Recipe Detail with Ingredients List + `Slider`

Key widgets: `Slider`, `ListView.builder` with `shrinkWrap`, `Expanded`.

```dart
class _RecipeDetailState extends State<RecipeDetail> {

  int _sliderVal = 1; // multiplier for servings

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.label),
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // go back
        ),
      ),
      body: Column(
        children: [
          Image.asset(widget.recipe.imageUrl, height: 300, width: 300),
          Text(widget.recipe.label, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.recipe.ingredients.length,
              itemBuilder: (context, index) {
                final ing = widget.recipe.ingredients[index];
                return Text(
                  '${_sliderVal * ing.quantity} ${ing.measure} ${ing.name}',
                  textAlign: TextAlign.center,
                );
              },
            ),
          ),
          Slider(
            min: 1,
            max: 10,
            divisions: 9,
            value: _sliderVal.toDouble(),
            activeColor: Colors.deepOrange,
            label: '${_sliderVal * widget.recipe.servings} servings',
            onChanged: (value) {
              setState(() => _sliderVal = value.toInt()); // rebuild on change
            },
          ),
        ],
      ),
    );
  }
}
```

### `Stack` + `Positioned` (Recipe Header Design)

`Stack` lets you overlap widgets on top of each other.  
`Positioned` places a child at an exact location within the Stack.

```dart
Stack(
  clipBehavior: Clip.none, // allows children to overflow outside the Stack bounds
  children: [
    // Bottom layer — background image
    Image.asset('assets/temp1.png', width: double.infinity, height: 250, fit: BoxFit.cover),

    // Middle layer — semi-transparent gradient at the bottom
    Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black87, Colors.transparent],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Recipe Name', style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    ),

    // Top layer — heart icon top-right
    Positioned(
      top: 10,
      right: 10,
      child: CircleAvatar(
        backgroundColor: Colors.black38,
        child: Icon(Icons.favorite_border, color: Colors.white),
      ),
    ),

    // Badge overflowing bottom edge
    Positioned(
      bottom: -15,  // negative value → pushes DOWN past the Stack's bottom edge
      left: 16,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('Prep: 30 min', style: TextStyle(color: Colors.white)),
      ),
    ),
  ],
)
```

**Key `Stack` rules:**
- Children listed later appear **on top**
- `Positioned` uses `top`, `bottom`, `left`, `right` offsets from the Stack's edges
- Negative offsets push elements **outside** the Stack (requires `clipBehavior: Clip.none`)
- Non-`Positioned` children are placed at `Alignment.topLeft` by default

---

## LAB 5–7 (Themes / Async / Scrollable Widgets)

---

## 1. What is a Theme in Flutter?

A **theme** defines the global visual style of your app — colors, fonts, background colors, card colors, etc.  
It is set inside `MaterialApp` using the `theme` property.

---

## 2. Basic Theme (Single / Light Theme)

```dart
MaterialApp(
  theme: ThemeData(
    primarySwatch: Colors.deepOrange,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  ),
)
```

**Key `ThemeData` properties:**

| Property | What it controls |
|---|---|
| `primarySwatch` | Main color used for AppBar, buttons, etc. |
| `scaffoldBackgroundColor` | Background color of the Scaffold |
| `cardColor` | Background color of Card widgets |
| `textTheme` | Default text styles across the app |
| `brightness` | `Brightness.light` or `Brightness.dark` |

---

## 3. Theme using `ColorScheme.fromSeed` (Lab 6)

```dart
MaterialApp(
  title: 'Shop App',
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
  ),
)
```

`ColorScheme.fromSeed` automatically generates a full Material 3 color palette from a single seed color.

---

## 4. Dark Theme + Light Theme + Toggle Button (Lab 5)

This is the most important topic.

### Step 1 — Convert root widget to `StatefulWidget`

The theme state must live at the top level so the entire app rebuilds when it changes.

```dart
class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  State<RecipeList> createState() => _RecipeListState();
}
```

### Step 2 — Add `_isDarkMode` state + toggle callback

```dart
class _RecipeListState extends State<RecipeList> {

  bool _isDarkMode = false; // tracks current mode

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode; // flip the flag → triggers rebuild
    });
  }
```

### Step 3 — Define both themes inside `MaterialApp`

```dart
MaterialApp(
  theme: ThemeData(                         // ── Light Theme
    brightness: Brightness.light,
    primarySwatch: Colors.deepOrange,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  ),
  darkTheme: ThemeData(                     // ── Dark Theme
    brightness: Brightness.dark,
    primarySwatch: Colors.deepOrange,
    scaffoldBackgroundColor: Colors.grey[900],
    cardColor: Colors.grey[850],
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  ),
  themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light, // controlled by state
  home: MyHomePage(
    onToggleTheme: _toggleTheme,
    isDarkMode: _isDarkMode,
  ),
)
```

### Step 4 — Pass callback down and add toggle button in AppBar

```dart
class MyHomePage extends StatefulWidget {
  final VoidCallback onToggleTheme; // receives the toggle function
  final bool isDarkMode;            // receives the current mode flag

  const MyHomePage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Inside build():
AppBar(
  backgroundColor: Colors.deepOrange,
  actions: [
    IconButton(
      tooltip: isDarkMode ? 'Switch to Light' : 'Switch to Dark',
      icon: Icon(
        isDarkMode ? Icons.light_mode : Icons.dark_mode, // icon switches
        color: Colors.white,
      ),
      onPressed: onToggleTheme, // calls the toggle on tap
    ),
  ],
)
```

### Full Toggle Flow

```
User taps icon
    → onToggleTheme() is called
    → setState() flips _isDarkMode
    → MaterialApp rebuilds
    → themeMode switches between ThemeMode.light / ThemeMode.dark
    → entire app repaints in the new theme
```

---

## 5. `ThemeMode` Values

| Value | Meaning |
|---|---|
| `ThemeMode.light` | Always use the light theme |
| `ThemeMode.dark` | Always use the dark theme |
| `ThemeMode.system` | Follow the device system setting |

---

## 6. Accessing Theme in Child Widgets

```dart
Theme.of(context).primaryColor
Theme.of(context).scaffoldBackgroundColor
Theme.of(context).cardColor
Theme.of(context).textTheme.bodyMedium
Theme.of(context).colorScheme.primary
```

---

## 7. Lab 6 — Async Programming

### `async` / `await` Basics

```dart
Future<bool> login(String username, String password) async {
  setState(() => _isLoading = true);           // show spinner
  await Future.delayed(Duration(seconds: 3));   // simulate network delay
  setState(() => _isLoading = false);           // hide spinner
  return username == 'zhassan' && password == 'pass99';
}
```

### Calling async and navigating after result

```dart
void handleLogin() async {
  bool success = await login(_username, _password);

  if (success) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ProductListPage()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Wrong username or password'),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}
```

### `FutureBuilder` — display async data in UI

```dart
FutureBuilder<List<Product>>(
  future: fetchProducts(), // async function returns a Future
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator()); // loading
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}')); // error
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No data found')); // empty
    } else {
      final products = snapshot.data!;
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(products[index].name));
        },
      );
    }
  },
)
```

### Task 3 — `addHello` / `greetUser` / `sayGoodbye`

```dart
// Part 1 — synchronous, takes a string and returns greeting
String addHello(String user) {
  return 'Hello $user';
}

// Part 2 — awaits fetchUsername() then passes to addHello()
Future<String> greetUser() async {
  var name = await fetchUsername(); // await the async fetch
  return addHello(name);            // compose greeting
}

// Part 3 — awaits logoutUser() inside try/catch
Future<String> sayGoodbye() async {
  try {
    var result = await logoutUser();                 // success path
    return '$result Thanks, see you next time';
  } catch (e) {
    return 'Failed';                                 // error path
  }
}
```

---

## 8. Lab 7 — Scrollable Widgets

### `ListView.builder`

```dart
ListView.builder(
  itemCount: recipes.length,
  itemBuilder: (context, index) {
    return Card(
      child: ListTile(
        leading: Image.asset(recipes[index].imageUrl),
        title: Text(recipes[index].label),
        subtitle: Text(recipes[index].comments.first.text),
        trailing: Text(recipes[index].comments.first.timestamp),
      ),
    );
  },
)
```

### `GridView.builder`

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,          // number of columns
    crossAxisSpacing: 10,       // horizontal spacing
    mainAxisSpacing: 10,        // vertical spacing
  ),
  itemCount: recipes.length,
  itemBuilder: (context, index) {
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        title: Text(recipes[index].label),
      ),
      child: Image.asset(recipes[index].imageUrl, fit: BoxFit.cover),
    );
  },
)
```

### `ScrollController` — detect top / bottom

```dart
class _ExploreScreenState extends State<ExploreScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener); // attach listener
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      bool isTop = _scrollController.position.pixels == 0;
      setState(() {
        _scrollStatus = isTop ? 'Scrolled to top' : 'Scrolled to bottom';
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // ALWAYS dispose to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController, // attach to ListView
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(recipes[index].label));
      },
    );
  }
}
```

---

## 9. Quick Cheat Sheet

| Concept | Key Widget / Class |
|---|---|
| App-wide styling | `ThemeData` inside `MaterialApp` |
| Switch themes at runtime | `setState` + `themeMode` property |
| Read theme in any widget | `Theme.of(context)` |
| Generate color palette | `ColorScheme.fromSeed(seedColor: ...)` |
| Async operation | `async` / `await` / `Future` |
| Simulate delay | `await Future.delayed(Duration(seconds: n))` |
| Show async data in UI | `FutureBuilder` |
| Scrollable list | `ListView.builder` |
| Scrollable grid | `GridView.builder` |
| Detect scroll edges | `ScrollController` + `addListener` |
| Loading indicator | `CircularProgressIndicator()` |
| Show toast / message | `ScaffoldMessenger.of(context).showSnackBar(...)` |
| Navigate to new screen | `Navigator.push(...)` |
| Navigate and remove previous | `Navigator.pushReplacement(...)` |
| Go back | `Navigator.pop(context)` |

---

Good luck on your exam!
