import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teachers_assistant/pages/home_page.dart';
import 'package:teachers_assistant/pages/login_page.dart';
import 'package:teachers_assistant/pages/signup_page.dart';
import 'package:teachers_assistant/services/auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthService _authService = AuthService();
  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    final userId = await _authService.getUserIdFromPreferences();
    if (userId != null) {
      _user = _authService.getCurrentUser();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        // '/': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
      },
      home: _isLoading
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : _user != null
              ? HomePage()
              : LoginPage(),
    );
  }
}
