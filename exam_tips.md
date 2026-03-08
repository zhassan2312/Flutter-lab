# Flutter Exam — Deep Tips, Logic & Q&A

This document covers the **why** behind each concept, common traps, and exam-style questions with answers.

---

## PART 1 — Widget Tree & Rendering Logic

### How Flutter actually draws the screen

Flutter builds a **widget tree** → from that it builds an **element tree** → then a **render tree**.  
Every time `setState()` is called, Flutter re-runs `build()` on that widget and its children, comparing the new tree to the old one (diffing), and only repaints what changed.

```
Widget Tree        Element Tree       Render Tree
(your code)  →  (framework manages) → (pixels on screen)
```

**Tip:** `build()` can be called many times per second. Never do heavy computation inside `build()` — always pre-compute or cache results.

---

### `StatelessWidget` vs `StatefulWidget` — The Real Difference

| | `StatelessWidget` | `StatefulWidget` |
|---|---|---|
| Can change after being built? | ❌ | ✅ |
| Has a `State` object? | ❌ | ✅ |
| `setState()` available? | ❌ | ✅ |
| Re-builds when parent rebuilds? | ✅ both rebuild | ✅ both rebuild |
| Re-builds on its own? | ❌ | ✅ (via `setState`) |

**Q: If both rebuild when the parent rebuilds, why use `StatefulWidget` at all?**  
A: `StatefulWidget` can also trigger a rebuild **on its own** by calling `setState()` — for example when a button is tapped, a timer fires, or async data arrives. `StatelessWidget` cannot do this.

**Q: Can a `StatelessWidget` show different UI for different inputs?**  
A: Yes — it re-renders whenever the parent passes different constructor arguments. It just cannot change itself independently.

---

## PART 2 — Layout Deep Dive

### The Golden Rule: Every widget needs bounded constraints

Flutter passes constraints (min/max width & height) **down** the tree.  
Widgets report their size **up** the tree.  
The parent then decides where to place each child.

**Common error: "RenderBox was given unbounded constraints"**  
This happens when you put a `ListView` or `Column` inside another `Column` without `Expanded` or a fixed height.

```dart
// ❌ WRONG — inner Column has infinite height inside outer Column
Column(children: [
  Column(children: [...]) // Flutter doesn't know how tall this is
])

// ✅ CORRECT — use Expanded to give it a bounded height
Column(children: [
  Expanded(
    child: Column(children: [...])
  )
])
```

---

### `Column` vs `Row` — Axis Terminology

| Widget | Main Axis | Cross Axis |
|---|---|---|
| `Column` | Vertical ↕ | Horizontal ↔ |
| `Row` | Horizontal ↔ | Vertical ↕ |

- `mainAxisAlignment` — controls spacing **along** the direction of flow
- `crossAxisAlignment` — controls alignment **perpendicular** to the direction of flow

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,    // centers children vertically
  crossAxisAlignment: CrossAxisAlignment.start,   // aligns children to the left
)
```

---

### `Expanded` vs `Flexible` vs `SizedBox`

| Widget | What it does |
|---|---|
| `Expanded` | Forces child to fill ALL remaining space (flex default 1) |
| `Flexible` | Lets child take UP TO its available space (can be smaller) |
| `SizedBox` | Fixed size gap or wrapper |

```dart
Row(children: [
  Expanded(flex: 3, child: Container(color: Colors.red)),   // 30%
  Expanded(flex: 7, child: Container(color: Colors.blue)),  // 70%
])
```

**Q: What does `flex` mean?**  
A: Total flex units = sum of all flex values. Each child gets `(its flex / total) * available space`.  
Example: flex:3 + flex:7 = 10 total. Red gets 3/10 = 30%, blue gets 7/10 = 70%.

---

### `Container` — the Swiss Army Knife

```dart
Container(
  width: 200,
  height: 100,
  margin: EdgeInsets.all(8),            // space OUTSIDE the container
  padding: EdgeInsets.all(16),          // space INSIDE, between border and child
  alignment: Alignment.center,          // aligns the child inside
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
    border: Border.all(color: Colors.black, width: 2),
    gradient: LinearGradient(
      colors: [Colors.blue, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: Text('Hello'),
)
```

**Tip:** You cannot use both `color` and `decoration` at the same time — put the color inside `BoxDecoration`.

---

### `Stack` + `Positioned` — Layering Logic

`Stack` places children on top of each other (like CSS `position: absolute`).

```
Stack children order:
  children[0]  ← bottom layer (drawn first)
  children[1]  ← middle layer
  children[2]  ← top layer (drawn last, appears in front)
```

`Positioned` coordinates are measured **from the Stack's edges**:

```
Stack box:
┌─────────────────────────┐
│  top: 10, left: 10      │ ← top-left area
│                         │
│                         │
│        bottom: 0        │ ← flush with bottom edge
│  left: 0,   right: 0    │ ← full width at bottom
└─────────────────────────┘
```

Negative values go OUTSIDE the box (only works if `clipBehavior: Clip.none`):
```dart
Positioned(bottom: -15, ...) // 15px below the bottom edge of the Stack
```

---

### `CircleAvatar`

```dart
// With initials (no image)
CircleAvatar(
  radius: 50,
  backgroundColor: Colors.blue,
  child: Text('JD', style: TextStyle(color: Colors.white, fontSize: 24)),
)

// With a network image
CircleAvatar(
  radius: 50,
  backgroundImage: NetworkImage('https://example.com/photo.jpg'),
)

// With a local asset image
CircleAvatar(
  radius: 50,
  backgroundImage: AssetImage('assets/photo.png'),
)
```

---

## PART 3 — Navigation Logic

### How `Navigator` works (Stack of screens)

Flutter's `Navigator` maintains a **stack** of routes (screens).

```
Initial:   [HomeScreen]
After push: [HomeScreen, DetailScreen]  ← DetailScreen is on top (visible)
After pop:  [HomeScreen]                 ← back to HomeScreen
```

```dart
// Go to a new screen (push on top)
Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen()));

// Go back (pop the top screen)
Navigator.pop(context);

// Replace current screen (pop then push — user can't go back)
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
```

**Q: When to use `pushReplacement` instead of `push`?**  
A: After a successful login — you don't want the user pressing Back to return to the login screen.

---

### `PageRouteBuilder` — Custom Animated Transitions

```dart
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => MyPage(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    // animation goes from 0.0 to 1.0 as the screen enters
    // secondaryAnimation goes from 0.0 to 1.0 as THIS screen is pushed away
    var tween = Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.ease));
    return SlideTransition(position: animation.drive(tween), child: child);
  },
)
```

`Offset(1.0, 0.0)` = 100% of the screen width to the right → slides in from right.  
`Offset(0.0, 1.0)` = 100% of the screen height downward → slides in from bottom.

---

## PART 4 — State Management Patterns

### Passing callbacks down (Prop Drilling)

When a child needs to trigger a state change in a parent, pass a callback function as a constructor argument.

```
_RecipeListState       (owns _isDarkMode + _toggleTheme)
    ↓ passes onToggleTheme: _toggleTheme
MyHomePage             (receives VoidCallback onToggleTheme)
    ↓ calls onToggleTheme on button tap
_RecipeListState       (setState runs, themeMode updates, entire tree rebuilds)
```

```dart
// Parent passes callback:
home: MyHomePage(onToggleTheme: _toggleTheme, isDarkMode: _isDarkMode)

// Child receives and uses it:
class MyHomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  const MyHomePage({required this.onToggleTheme, required this.isDarkMode, ...});
}

// In AppBar:
IconButton(onPressed: widget.onToggleTheme, icon: Icon(...))
```

---

### `initState`, `build`, `dispose` Lifecycle

```dart
class _MyWidgetState extends State<MyWidget> {

  @override
  void initState() {
    super.initState();
    // ← Called ONCE when the widget is first inserted into the tree
    // Use for: initializing controllers, adding listeners, starting async operations
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    // ← Called every time the widget needs to re-render
    // Use for: returning widgets (UI only). Never do side effects here.
    return Container();
  }

  @override
  void dispose() {
    // ← Called ONCE when the widget is permanently removed from the tree
    // Use for: cleaning up controllers, removing listeners to prevent memory leaks
    _scrollController.dispose();
    super.dispose();
  }
}
```

**Exam tip:** Always call `super.initState()` first and `super.dispose()` last.  
**Exam tip:** Always `dispose()` a `ScrollController`, `AnimationController`, or `TextEditingController` — forgetting causes memory leaks.

---

## PART 5 — Async Programming Deep Dive

### What is a `Future`?

A `Future<T>` represents a value that **will be available later** (after a delay, network call, file read, etc.).  
It can be in 3 states: pending → completed with value → completed with error.

```dart
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2)); // simulate wait
  return 'Hello'; // resolves with this value after 2s
}
```

### `async` / `await` — The Rules

1. A function marked `async` **always returns a `Future`**, even if you return a plain value.
2. You can only use `await` inside an `async` function.
3. `await` **pauses execution of that function** until the Future completes — but does NOT block the UI thread.
4. Code after `await` only runs after the Future resolves.

```dart
// Without async/await (callback hell):
fetchData().then((value) {
  print(value);
}).catchError((e) {
  print('Error: $e');
});

// With async/await (clean):
try {
  String value = await fetchData();
  print(value);
} catch (e) {
  print('Error: $e');
}
```

### `Future.delayed` — Simulating Network Calls

```dart
await Future.delayed(Duration(seconds: 3)); // waits 3 seconds then continues
```

**Q: Does `Future.delayed` block the UI?**  
A: No. Flutter runs on a single thread but uses an **event loop**. `await` suspends the current function and returns control to Flutter so the UI stays responsive. When the Future completes, it resumes from where it stopped.

---

### Loading Spinner Pattern

```dart
bool _isLoading = false;

Future<void> _doSomething() async {
  setState(() => _isLoading = true);      // show spinner
  await someAsyncOperation();              // wait (UI stays responsive)
  setState(() => _isLoading = false);     // hide spinner
}

// In build():
_isLoading
  ? CircularProgressIndicator()   // shows while loading
  : ElevatedButton(               // shows when done
      onPressed: _doSomething,
      child: Text('Go'),
    )
```

---

### `FutureBuilder` — Displaying Async Data

`FutureBuilder` rebuilds whenever the Future's state changes.

```dart
FutureBuilder<List<Product>>(
  future: fetchProducts(),  // ← IMPORTANT: don't call async functions inline here
                            //   in a StatefulWidget — store the Future in initState
  builder: (context, snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
        return CircularProgressIndicator();        // still loading
      case ConnectionState.done:
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');  // something went wrong
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No items');                  // empty result
        }
        return ListView.builder(                    // show the data
          itemCount: snapshot.data!.length,
          itemBuilder: (_, i) => ListTile(title: Text(snapshot.data![i].name)),
        );
      default:
        return SizedBox.shrink();
    }
  },
)
```

**Critical tip:** If you put `future: fetchProducts()` directly in `FutureBuilder` inside `build()`, it will restart the fetch every time the widget rebuilds. Store the Future in `initState`:

```dart
late Future<List<Product>> _productsFuture;

@override
void initState() {
  super.initState();
  _productsFuture = fetchProducts(); // called ONCE
}

// In build:
FutureBuilder(future: _productsFuture, ...)
```

---

### Parsing JSON from Assets

```dart
import 'package:flutter/services.dart';
import 'dart:convert';

Future<List<Product>> fetchProducts() async {
  final String jsonString = await rootBundle.loadString('assets/products.json');
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((e) => Product.fromJson(e)).toList();
}
```

Model with `fromJson`:
```dart
class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }
}
```

**`pubspec.yaml` — declaring assets:**
```yaml
flutter:
  assets:
    - assets/            # exposes ALL files in the assets/ folder
    - assets/products.json  # or declare specific files
```

---

### Error Handling with `try` / `catch`

```dart
Future<String> sayGoodbye() async {
  try {
    var result = await logoutUser(); // might throw
    return '$result Thanks, see you next time';
  } catch (e) {
    return 'Failed'; // handle the error gracefully
  }
}
```

**Q: What happens if you don't catch an error in an async function?**  
A: The Future completes with an error. If uncaught, it becomes an unhandled exception — in Flutter this shows a red error screen in debug mode.

---

## PART 6 — Theme System Deep Dive

### How `ThemeData` flows through the widget tree

`MaterialApp` puts the theme into Flutter's **InheritedWidget** system.  
Any widget anywhere in the tree can access it via `Theme.of(context)` — no need to pass it manually.

```
MaterialApp (provides ThemeData via InheritedWidget)
  └── Scaffold
        └── AppBar     → picks up primaryColor automatically
        └── Body
              └── Text → can call Theme.of(context).textTheme.bodyMedium
```

### `ThemeMode` Logic

```dart
themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light
```

| `themeMode` | Which theme is used |
|---|---|
| `ThemeMode.light` | Always `theme:` |
| `ThemeMode.dark` | Always `darkTheme:` |
| `ThemeMode.system` | Follows device setting (day = `theme:`, night = `darkTheme:`) |

**Q: What if I set `themeMode: ThemeMode.dark` but don't provide `darkTheme`?**  
A: Flutter falls back to the light `theme`. Always define both when using toggle.

---

### `ColorScheme.fromSeed` vs `primarySwatch`

| | `primarySwatch` | `ColorScheme.fromSeed` |
|---|---|---|
| Material version | Material 2 | Material 3 |
| How many colors? | Generates 10 shades | Generates full palette (primary, secondary, surface, error, etc.) |
| Recommendation | Older apps | New apps (Flutter 3+) |

```dart
// Material 2 style:
theme: ThemeData(primarySwatch: Colors.deepOrange)

// Material 3 style:
theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal))
```

---

### Reading Theme Colors in Widgets

```dart
// Background of body
color: Theme.of(context).scaffoldBackgroundColor

// Primary color (AppBar, buttons)
color: Theme.of(context).colorScheme.primary

// Card background
color: Theme.of(context).cardColor

// Text style
style: Theme.of(context).textTheme.bodyMedium

// InversePrimary (often used for AppBar background in Material 3)
color: Theme.of(context).colorScheme.inversePrimary
```

---

## PART 7 — Scrollable Widgets Deep Dive

### `ListView` variants

| Variant | Use when |
|---|---|
| `ListView(children: [...])` | Short, known list of items |
| `ListView.builder(...)` | Long or infinite list — lazy builds items as needed |
| `ListView.separated(...)` | List with dividers between items |

```dart
// ListView.builder — most common
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text(items[index]));
  },
)

// ListView.separated — adds dividers automatically
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (context, index) => Divider(),
  itemBuilder: (context, index) => ListTile(title: Text(items[index])),
)
```

**Q: Why use `ListView.builder` instead of `ListView`?**  
A: `ListView.builder` only builds widgets for items currently visible on screen (lazy). `ListView(children: [...])` builds all items upfront — wasteful for long lists.

---

### `SingleChildScrollView` vs `ListView`

| | `SingleChildScrollView` | `ListView` |
|---|---|---|
| How many children? | One (can be a `Column`) | Many (list items) |
| Lazy loading? | ❌ No | ✅ Yes (builder) |
| Scroll direction | Horizontal or Vertical | Horizontal or Vertical |
| Use when | Wrapping a short scrollable layout | Building item lists |

```dart
// Horizontal scrollbar (Lab 3 / Lab 4 status bar):
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(children: [
    Container(width: 200, color: Colors.red),
    Container(width: 200, color: Colors.green),
    Container(width: 200, color: Colors.blue),
  ]),
)
```

---

### `GridView.builder` — Two-Dimensional Lists

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,       // columns
    crossAxisSpacing: 8,     // gap between columns
    mainAxisSpacing: 8,      // gap between rows
    childAspectRatio: 1.0,   // width/height ratio of each cell (1.0 = square)
  ),
  itemCount: items.length,
  itemBuilder: (context, index) {
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        title: Text(items[index].name),
      ),
      child: Image.asset(items[index].imageUrl, fit: BoxFit.cover),
    );
  },
)
```

**`childAspectRatio`:**
- `1.0` = square cells
- `0.75` = taller than wide (portrait)
- `1.5` = wider than tall (landscape)

---

### `ScrollController` — Detecting Position

```dart
final ScrollController _controller = ScrollController();

@override
void initState() {
  super.initState();
  _controller.addListener(_onScroll); // register listener once
}

void _onScroll() {
  double current = _controller.position.pixels;       // current scroll position (px from top)
  double max = _controller.position.maxScrollExtent; // total scrollable distance

  if (_controller.position.atEdge) {
    if (current == 0) {
      print('At the TOP');
    } else {
      print('At the BOTTOM');
    }
  }

  // You can also detect percentage scrolled:
  double percent = current / max;
  print('Scrolled ${(percent * 100).toStringAsFixed(0)}%');
}

@override
void dispose() {
  _controller.dispose(); // MANDATORY — prevents memory leak
  super.dispose();
}
```

Attach to `ListView`:
```dart
ListView.builder(controller: _controller, ...)
```

---

## PART 8 — Common Widgets Quick Reference

### `AppBar`

```dart
AppBar(
  title: Text('My App'),
  backgroundColor: Colors.deepOrange,
  foregroundColor: Colors.white,      // color of title + icons
  toolbarHeight: 100,                 // taller AppBar
  leading: IconButton(                // icon on the LEFT
    icon: Icon(Icons.menu),
    onPressed: () {},
  ),
  actions: [                          // icons on the RIGHT
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
    IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
  ],
)
```

---

### `Scaffold`

```dart
Scaffold(
  appBar: AppBar(...),
  body: Center(child: Text('Hello')),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
  bottomNavigationBar: BottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
    ],
  ),
  drawer: Drawer(child: ListView(...)),  // slide-out menu from left
)
```

---

### `SnackBar`

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Something happened'),
    backgroundColor: Colors.deepOrange,
    duration: Duration(seconds: 2),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {},
    ),
  ),
);
```

---

### `Slider`

```dart
Slider(
  min: 1,
  max: 10,
  divisions: 9,                       // number of discrete steps
  value: _sliderVal.toDouble(),       // MUST be double
  label: '$_sliderVal',               // tooltip shown while dragging
  activeColor: Colors.deepOrange,
  inactiveColor: Colors.grey,
  onChanged: (double value) {
    setState(() => _sliderVal = value.toInt());
  },
)
```

**Tip:** `value` must be a `double`. If your state variable is `int`, call `.toDouble()` when passing and `.toInt()` when saving.

---

### `TextFormField` / `TextField`

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Username',
    hintText: 'Enter your username',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.person),
  ),
  obscureText: true,     // hides text (for passwords)
  keyboardType: TextInputType.emailAddress,
  onChanged: (value) {
    setState(() => _username = value);
  },
)
```

---

### `Image.asset` vs `Image.network`

```dart
Image.asset('assets/photo.png',   // from pubspec.yaml declared assets
  width: 300,
  height: 200,
  fit: BoxFit.cover,              // fills the box, may crop
)

Image.network('https://example.com/photo.jpg',
  loadingBuilder: (context, child, progress) {
    return progress == null ? child : CircularProgressIndicator();
  },
)
```

`BoxFit` values:
| Value | Behavior |
|---|---|
| `cover` | Fill box, maintain aspect ratio, may crop |
| `contain` | Fit entirely inside box, may leave gaps |
| `fill` | Stretch to fill, ignores aspect ratio |
| `fitWidth` | Match width, may overflow height |
| `fitHeight` | Match height, may overflow width |

---

## PART 9 — Exam Q&A

**Q: What is `BuildContext`?**  
A: A handle to the widget's location in the widget tree. Every `build()` method receives one. Used to access inherited data like `Theme.of(context)`, navigate with `Navigator.of(context)`, or show snackbars with `ScaffoldMessenger.of(context)`.

---

**Q: What is `super.key` and why is it in every constructor?**  
A: `key` is a Flutter mechanism to uniquely identify widgets in the tree — helps Flutter efficiently update the UI. Passing `super.key` forwards the key to the parent class. You almost never need to provide a key yourself; the pattern is just boilerplate.

---

**Q: What is `const` in Flutter widgets?**  
A: `const` means "this widget is compile-time constant and will never change". Flutter can reuse the same object across rebuilds instead of creating a new one — a performance optimization. Use it whenever possible on `Text`, `SizedBox`, `Icon`, etc.

```dart
const SizedBox(height: 16)   // ✅ good — reuses the object
SizedBox(height: 16)          // also works, just slightly less efficient
```

---

**Q: What does `required` mean in a constructor?**  
A: It means the caller must provide that argument. Without it, Dart will give a compile-time error.

```dart
const MyWidget({required this.label});  // caller must supply label:
MyWidget(label: 'Hello')  // ✅
MyWidget()                // ❌ compile error
```

---

**Q: What is `late` in Dart?**  
A: Declares a non-nullable variable that will be initialized before it's first used (but not at declaration time). Useful in `initState()` for Futures:

```dart
late Future<List<Product>> _future; // declared without value

@override
void initState() {
  super.initState();
  _future = fetchProducts(); // assigned here — before build() is called
}
```

---

**Q: What is `final` vs `const` vs regular variable?**  
A: 
- `var x = 5;` — can be reassigned with `x = 10;`
- `final x = 5;` — assigned once at runtime, cannot be reassigned
- `const x = 5;` — compile-time constant, value known at compile time

```dart
final name = widget.recipe.label; // set once from another value — use final
const pi = 3.14159;               // known at compile time — use const
int counter = 0;                  // will change — use var or typed variable
```

---

**Q: Difference between `Navigator.pop` and `Navigator.pushReplacement`?**  
A:
- `pop` — removes the top screen, reveals what was underneath
- `pushReplacement` — replaces the current screen with a new one (no going back with pop)
- `push` — adds a new screen on top (old screen stays, pop can return to it)

---

**Q: Why does `FutureBuilder` re-fetch data on every rebuild?**  
A: Because `future: fetchProducts()` calls the function fresh each time `build()` runs.  
Fix: Store the `Future` in a state variable in `initState()` and pass that variable to `FutureBuilder`.

---

**Q: What is `shrinkWrap: true` in a `ListView`?**  
A: By default, `ListView` tries to take up as much vertical space as possible. `shrinkWrap: true` tells it to only take as much space as its content needs. Use it when a `ListView` is inside a `Column` or `SingleChildScrollView`.

---

**Q: What is `mainAxisSize: MainAxisSize.min` on a `Column`?**  
A: By default, `Column` expands to fill its parent's height. `MainAxisSize.min` makes it shrink to fit its children. Useful inside `Card`, `Dialog`, or `AlertDialog`.

---

**Q: What is the difference between `margin` and `padding`?**  
A:
- `padding` — space **inside** the Container, between its border and its child
- `margin` — space **outside** the Container, between it and its neighbors

```
[ margin ][ border ][ padding ][ child ][ padding ][ border ][ margin ]
```

---

**Q: How do you load a file from assets in Flutter?**  
A:
1. Declare it in `pubspec.yaml` under `flutter: assets:`
2. Use `rootBundle.loadString('assets/myfile.json')` (requires `import 'package:flutter/services.dart'`)

---

**Q: What does `fit: BoxFit.cover` do to an image?**  
A: Scales the image to fill the entire box while keeping its aspect ratio. The image may be cropped on the sides or top/bottom but there are no blank areas.

---

**Q: Why use `GestureDetector` instead of just wrapping in a `TextButton`?**  
A: `GestureDetector` detects any gesture (tap, double tap, long press, swipe, etc.) on **any widget** without adding button visual effects (ripple, ink splash). Use it when you want tap detection on an image, container, or custom widget without button styling.

---

## PART 10 — Common Mistakes & How to Fix Them

| Mistake | Fix |
|---|---|
| `setState` called but UI doesn't update | Make sure the variable being changed is inside `setState(() { ... })` |
| `RenderBox unbounded constraints` | Wrap `ListView` in `Expanded` or give it a fixed height |
| Image not showing (`assets/img.png`) | Check pubspec.yaml has `assets:` declared; check path is correct and no extra spaces |
| `Navigator.pop` crashes | The screen has no previous route — use `pushReplacement` on the previous screen |
| Dark theme not applying | Make sure both `theme:` and `darkTheme:` are set in `MaterialApp` |
| `FutureBuilder` refetches on every tap | Store Future in `initState`, not inline in `build()` |
| `Slider` value error | Make sure `value` is between `min` and `max`; use `.toDouble()` if state is `int` |
| `color` + `decoration` conflict | Move the `color` inside `BoxDecoration`, not as separate `color:` property on `Container` |
| `dispose()` missing for controllers | Always call `.dispose()` on `ScrollController`, `TextEditingController`, `AnimationController` |
| `await` outside `async` function | Mark the enclosing function as `async` |

---

Good luck on your exam!
