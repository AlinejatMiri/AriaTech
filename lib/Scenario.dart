import 'package:flutter/material.dart';

void main() {
  runApp(StudentApp());
}

class StudentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainScreen());
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _counter = 0;
  String studentName = "";

  final List<String> courses = [
    "Flutter Development",
    "Web Development",
    "Data Structures",
    "Machine Learning",
    "UI/UX Design",
  ];

  void _onFabPressed() {
    setState(() {
      _counter++;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Course ideas added: $_counter")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Course App"),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Welcome Student",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text("Home")),
            ListTile(leading: Icon(Icons.book), title: Text("Courses")),
            ListTile(leading: Icon(Icons.person), title: Text("Profile")),
          ],
        ),
      ),

      body: _buildBody(),

      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        child: Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Courses"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_currentIndex == 0) return _homeTab();
    if (_currentIndex == 1) return _coursesTab();
    return _profileTab();
  }

  // ---------------- HOME TAB ----------------
  Widget _homeTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Welcome Card
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: Colors.blue.shade100,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: [
                        TextSpan(text: "Welcome "),
                        TextSpan(
                          text: "Student!\n",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: "Start learning today 🚀"),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // GridView Categories
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _gridItem(Icons.code, "Programming"),
              _gridItem(Icons.design_services, "Design"),
              _gridItem(Icons.analytics, "Data"),
              _gridItem(Icons.language, "Languages"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gridItem(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icon, size: 40), SizedBox(height: 10), Text(title)],
      ),
    );
  }

  // ---------------- COURSES TAB ----------------
  Widget _coursesTab() {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return ListTile(leading: Icon(Icons.book), title: Text(courses[index]));
      },
    );
  }

  // ---------------- PROFILE TAB ----------------
  Widget _profileTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "Enter your name",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                studentName = value;
              });
            },
          ),
          SizedBox(height: 20),
          Text(
            studentName.isEmpty ? "Hello!" : "Hello, $studentName 👋",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
