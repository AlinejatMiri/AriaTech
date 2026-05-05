import 'package:flutter/material.dart';

void main() {
  runApp(StudentCourseApp());
}

class StudentCourseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainScreen());
  }
}

//////////////////////////////////////////////////////////////
// ROOT STATEFUL WIDGET (Instruction 50)
//////////////////////////////////////////////////////////////

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // ✅ Instruction 51
  int selectedIndex = 0;

  // ✅ Instruction 53 (Course List)
  final List<String> courses = [
    "Flutter Basics",
    "Dart Programming",
    "UI Design",
    "State Management",
    "Firebase",
    "REST APIs",
    "Animations",
    "Deployment",
  ];

  // ✅ Instruction 55 (TextEditingController)
  TextEditingController nameController = TextEditingController();
  String studentName = "";

  //////////////////////////////////////////////////////////////
  // Instruction 52 → Three Tab Methods
  //////////////////////////////////////////////////////////////

  Widget buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),

          Text("Welcome to Student App", style: TextStyle(fontSize: 18)),

          SizedBox(height: 20),

          // ✅ Instruction 54 (GridView)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(6, (index) {
              return Card(
                margin: EdgeInsets.all(8),
                child: Center(child: Text("Category ${index + 1}")),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildCoursesTab() {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return ListTile(leading: Icon(Icons.book), title: Text(courses[index]));
      },
    );
  }

  Widget buildProfileTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enter your name",
            ),
          ),

          SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              setState(() {
                studentName = nameController.text;
              });
            },
            child: Text("Save"),
          ),

          SizedBox(height: 10),

          Text("Student Name: $studentName"),
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////
  // MAIN BUILD
  //////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    // Tab switch logic
    Widget currentTab;
    if (selectedIndex == 0) {
      currentTab = buildHomeTab();
    } else if (selectedIndex == 1) {
      currentTab = buildCoursesTab();
    } else {
      currentTab = buildProfileTab();
    }

    return Scaffold(
      appBar: AppBar(title: Text("Student Course App")),

      //////////////////////////////////////////////////////////
      // Drawer (Instruction 57 testing required)
      //////////////////////////////////////////////////////////
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Menu", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: Text("Home"),
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Courses"),
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Profile"),
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      //////////////////////////////////////////////////////////
      // Body
      //////////////////////////////////////////////////////////
      body: currentTab,

      //////////////////////////////////////////////////////////
      // FloatingActionButton (Instruction 56)
      //////////////////////////////////////////////////////////
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("FAB Clicked!")));
        },
        child: Icon(Icons.add),
      ),

      //////////////////////////////////////////////////////////
      // BottomNavigationBar
      //////////////////////////////////////////////////////////
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
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
}
