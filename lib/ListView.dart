import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final List<String> courses = const [
    'Flutter Basics',
    'Dart Programming',
    'UI Design',
    'State Management',
    'FireBase Integration',
    'Final project',
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    const baseStyle = TextStyle(fontSize: 22, color: Colors.black87);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('List View Class')),
        body: ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: CircleAvatar(child: Text('$index +1')),
                title: Text(courses[index]),
                subtitle: const Text('Tap to view course details'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}
