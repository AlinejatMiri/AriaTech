import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Dashboard',
      home: Scaffold(
        backgroundColor: Colors.amber.shade100,
        appBar: AppBar(
          title: const Text('Student Dashboard'),
          leading: Icon(Icons.notifications),
          centerTitle: true,
        ),
        body: const Center(
          child: Column(
            children: [
              Text(
                'Name:Sayed Ali Nejat Miri\nStudent ID: Q01006758',
                style: TextStyle(fontSize: 20),
              ),
              Text('This is the Second text widget'),
            ],
          ),
        ),
      ),
    );
  }
}
