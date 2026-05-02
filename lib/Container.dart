import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Container Class')),
        body: Center(
          child: Container(
            width: 250,
            height: 150,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 8,
                  offset: Offset(2, 4),
                  color: Colors.black26,
                ),
              ],
            ),
            child: Text(
              'Container with size , margin, padding, color ,radius, and shadow',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
