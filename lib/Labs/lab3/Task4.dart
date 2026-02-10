import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveStatusBarApp());
}

class ResponsiveStatusBarApp extends StatelessWidget {
  const ResponsiveStatusBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Status Bar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StatusBarDemo(),
    );
  }
}

class StatusBarDemo extends StatelessWidget {
  const StatusBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Horizontal Status Bar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Horizontally Scrollable Status Bar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Horizontally scrolling container
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // First box: Fixed width
                  Container(
                    width: 120,
                    height: 80,
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: const Text(
                      'Fixed\n120px',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Second box: Takes 2/3 of remaining space
                  Container(
                    width: 300,
                    height: 80,
                    color: Colors.green,
                    alignment: Alignment.center,
                    child: const Text(
                      'Flex 2\n300px',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Third box: Takes 1/3 of remaining space
                  Container(
                    width: 150,
                    height: 80,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: const Text(
                      'Flex 1\n150px',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Responsive Status Bar (Adjusts to Screen Width):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Responsive row that adjusts to screen width
            Row(
              children: [
                // First box: Fixed width
                Container(
                  width: 120,
                  height: 80,
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: const Text(
                    'Fixed\n120px',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                // Second box: Takes 2x space (flex: 2)
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 80,
                    color: Colors.green,
                    alignment: Alignment.center,
                    child: const Text(
                      'Flex 2\n(2x space)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Third box: Takes 1x space (flex: 1)
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 80,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: const Text(
                      'Flex 1\n(1x space)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'The first example demonstrates overflow behavior with horizontal scrolling. The second example shows responsive layout that adjusts to screen width.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
