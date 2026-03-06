import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = '';
  String _password = '';
  bool _isLoading = false;  // Tracks loading state during async login

  // Simulates an async login check with a 2-second delay
  Future<bool> login(String username, String password) async {
    setState(() {
      _isLoading = true;  // Show spinner while awaiting result
    });

    await Future.delayed(const Duration(seconds: 3));  // Simulate network delay

    setState(() {
      _isLoading = false;  // Hide spinner after result
    });

    // Only "zhassan" / "pass99" is accepted
    if (username == 'zhassan' && password == 'pass99') {
      return true;
    } else {
      return false;
    }
  }

  // Triggered when Login button is pressed
  void handleLogin() async {
    bool success = await login(_username, _password);

    // Show success or failure feedback via SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Welcome Back!' : 'Wrong username or password'),
        backgroundColor: success ? Colors.teal : Colors.deepOrange,
      ),
    );
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
                // Username field
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _username = value;
                    });
                  },
                ),
                // Password field — text is hidden with obscureText
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                // Show spinner while loading, otherwise show Login button
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
