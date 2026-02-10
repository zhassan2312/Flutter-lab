import 'package:flutter/material.dart';

void main() {
  runApp(const BusinessCardApp());
}

class BusinessCardApp extends StatelessWidget {
  const BusinessCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Business Card',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BusinessCard(),
    );
  }
}

class BusinessCard extends StatelessWidget {
  const BusinessCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Business Card'),
      ),
      body: Center(
        child: Card(
          elevation: 8.0,
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Circular profile image
                const CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.blue,
                  child: Text(
                    'JD',
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Person's name
                const Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Professional title
                const Text(
                  'Software Engineer',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16.0),
                // Thin divider
                const Divider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16.0),
                // Row of clickable contact icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.phone),
                      onPressed: () {
                        // Handle phone action
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.email),
                      onPressed: () {
                        // Handle email action
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.business),
                      onPressed: () {
                        // Handle LinkedIn action
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
