import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void selectMenu(BuildContext context, String title) {
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title selected')));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Drawer Widget')),
        drawer: Drawer(
          child: Builder(
            builder: (context) {
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.indigo),
                    child: Text(
                      'Student Menu',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.dashboard),
                    title: const Text('Dashboard'),
                    onTap: () => selectMenu(context, 'Dashboard'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () => selectMenu(context, 'Settings'),
                  ),
                ],
              );
            },
          ),
        ),
        body: const Center(
          child: Text('Open the drawer from the AppBar menu icon.'),
        ),
      ),
    );
  }
}
