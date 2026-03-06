import 'package:flutter/material.dart';
import 'pages/product_list_page.dart';

// Entry point for Task 2 – combines Task 1 login with async product list
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const LoginPage(),
    );
  }
}

// ─── Login Page ───────────────────────────────────────────────────────────────

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = '';
  String _password = '';
  bool _isLoading = false;  // Controls spinner visibility

  // Async login: waits 2 seconds then validates credentials
  Future<bool> login(String username, String password) async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 3));  // Simulate network delay

    setState(() => _isLoading = false);

    return username == 'zhassan' && password == 'pass99';
  }

  // Called on button press – awaits login result then navigates or shows error
  void handleLogin() async {
    bool success = await login(_username, _password);

    if (success) {
      // Replace current route with ProductListPage on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProductListPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong username or password'),
          backgroundColor: Colors.deepOrange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 171, 64),
              borderRadius: BorderRadius.circular(20),
            ),
            height: 320,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Username input
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => _username = value),
                ),
                // Password input – characters hidden with obscureText
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => _password = value),
                ),
                // Spinner while awaiting async login, button otherwise
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: handleLogin,
                        child: const Text('Login'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
