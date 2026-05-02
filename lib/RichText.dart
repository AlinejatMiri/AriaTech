import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    const baseStyle = TextStyle(fontSize: 22, color: Colors.black87);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Rich Text Widget')),
        body: Center(
          child: RichText(
            text: const TextSpan(
              style: baseStyle,
              children: [
                TextSpan(text: 'flutter'),
                TextSpan(
                  text: 'RichText',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                TextSpan(text: 'allows'),
                TextSpan(
                  text: 'multiple styles',
                  style: TextStyle(
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: 'in one paragraph.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
