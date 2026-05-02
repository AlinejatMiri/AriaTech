import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ClipRRect widget')),
        body: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 280,
              height: 160,
              color: Colors.deepOrange,
              alignment: Alignment.center,
              child: const Text(
                'Rounded Rectangle',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
