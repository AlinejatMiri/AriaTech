import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  String inputText = "";

  TextEditingController controller = TextEditingController();

  // Bottom tabs content
  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens = [HomeTab(), CoursesTab(), ProfileTab()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      // ✅ AppBar
      appBar: AppBar(
        title: Text("Student Course App"),
        leading: Icon(Icons.menu),
        actions: [
          Icon(Icons.search),
          SizedBox(width: 10),
          Icon(Icons.notifications),
        ],
      ),

      // ✅ Drawer
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(title: Text("Home"), leading: Icon(Icons.home)),
            ListTile(title: Text("Courses"), leading: Icon(Icons.book)),
            ListTile(title: Text("Profile"), leading: Icon(Icons.person)),
          ],
        ),
      ),

      // ✅ Body (changes with BottomNavigationBar)
      body: _screens[_currentIndex],

      // ✅ FloatingActionButton (Counter)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _counter++;
          });
        },
        child: Icon(Icons.add),
      ),

      // ✅ BottomNavigationBar
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
}

//////////////////////////////////////////////////////////////
// HOME TAB
//////////////////////////////////////////////////////////////

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ✅ ClipRRect (Rounded banner)
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              margin: EdgeInsets.all(10),
              height: 150,
              color: Colors.blue,
              child: Center(
                child: Text(
                  "Welcome Banner",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),

          // ✅ SizedBox spacing
          SizedBox(height: 10),

          // ✅ RichText
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Learn ",
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: "Flutter ",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "Today!",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // ✅ GridView (6 items)
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
}

//////////////////////////////////////////////////////////////
// COURSES TAB
//////////////////////////////////////////////////////////////

class CoursesTab extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(courses[index]), leading: Icon(Icons.book));
      },
    );
  }
}

//////////////////////////////////////////////////////////////
// PROFILE TAB
//////////////////////////////////////////////////////////////

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String displayText = "";
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // ✅ Container (Styled profile card)
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
            ),
            child: Column(
              children: [
                Icon(Icons.person, size: 50),
                SizedBox(height: 10),
                Text("Student Name"),
              ],
            ),
          ),

          SizedBox(height: 20),

          // ✅ TextField
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enter something",
            ),
          ),

          SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              setState(() {
                displayText = controller.text;
              });
            },
            child: Text("Submit"),
          ),

          SizedBox(height: 10),

          Text("You typed: $displayText"),
        ],
      ),
    );
  }
}
