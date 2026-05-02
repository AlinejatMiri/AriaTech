import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('SizedBox Widget', style: TextStyle(fontSize: 22)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('First Text'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Button after vertical gap'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => print('hello world'),
                  child: const Text('Fixed Size Button'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
