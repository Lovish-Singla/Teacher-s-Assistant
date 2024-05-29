import 'package:flutter/material.dart';
import 'package:teachers_assistant/pages/login_page.dart';
import 'package:teachers_assistant/pages/student_form_page.dart';
import 'package:teachers_assistant/pages/student_list_page.dart';

import '../services/auth_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();

  final List<Widget> _pages = [
    StudentFormPage(),
    StudentListPage(),
  ];

  final List<String> _titles = [
    "Enter a new Student",
    "Student's List",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              bool confirmLogout = await _showLogoutConfirmationDialog(context);
              if (confirmLogout) {
                await _authService.signout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Form',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Students',
          ),
        ],
      ),
    );
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Logout'),
              content: Text('Are you sure you want to logout?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Logout'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
