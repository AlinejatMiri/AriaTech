import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectIndex = 0;
  final List<String> pages = ['Home Page', 'Course Page', 'Profile Page'];
  void changePage(int index) {
    setState(() {
      selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('BottomNavigationBar')),
        body: Center(
          child: Text(pages[selectIndex], style: const TextStyle(fontSize: 24)),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectIndex,
          onTap: changePage,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
