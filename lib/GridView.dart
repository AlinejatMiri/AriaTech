import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final List<IconData> icons = const [
    Icons.phone_android,
    Icons.laptop,
    Icons.watch,
    Icons.headphones,
    Icons.camera_alt,
    Icons.tablet,
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Grid View')),
        body: GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: icons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icons[index], size: 48, color: Colors.indigo),
            );
          },
        ),
      ),
    );
  }
}
