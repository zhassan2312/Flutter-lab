import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Labs',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Student Card'),
    );
  }
}
class MyHomePage extends StatelessWidget{
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            //name
            //Registration Number
            //Department
            //Hostel status
            //contact information
            //parent contact information
            Text('Name: Zohaib Hassan', style: TextStyle(fontSize: 20)),
            Text('Registration Number: 412221', style: TextStyle(fontSize: 20)),
            Text('Department: Computer Engineering', style: TextStyle(fontSize: 20)),
            Text('Hostel Status: Hostellite', style: TextStyle(fontSize: 20)),
            Text('Contact Information: +92 311 6699726', style: TextStyle(fontSize: 20)),
            Text('Parent Contact Information: +92 300 7699726', style: TextStyle(fontSize: 20)),
          ]
        )
      ),
    );
  }

}