import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String greeting = 'Enter your details';
  String errorMessage = '';

  void updateGreeting() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();

    setState(() {
      if (name.isEmpty) {
        errorMessage = 'Name cannot be empty';
        greeting = '';
      } else {
        errorMessage = '';
        greeting = 'Hello, $name\nEmail: $email';

        // ✅ Clear name field (Task 47)
        nameController.clear();
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Student Form')),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🔹 Name Field
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Student Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 Email Field (Task 45 & 46)
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),

                const SizedBox(height: 16),

                // 🔴 Error Message (Task 48)
                if (errorMessage.isNotEmpty)
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: updateGreeting,
                  child: const Text('Submit'),
                ),

                const SizedBox(height: 16),

                Text(
                  greeting,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
