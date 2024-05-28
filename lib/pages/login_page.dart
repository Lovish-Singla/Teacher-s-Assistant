import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_services.dart';
import '../widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome! Let's get you logged in.",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _emailController,
              hintText: 'Enter your email',
              labelText: 'Email',
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _passwordController,
              hintText: 'Enter your Password',
              labelText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                User? user = await _authService.signin(
                    _emailController.text, _passwordController.text);
                if (user != null) {
                  if (user.emailVerified) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    setState(() {
                      _errorMessage =
                          "Please verify your email before logging in.";
                    });
                  }
                } else {
                  setState(() {
                    _errorMessage = "Login failed. Please try again.";
                  });
                }
              },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text("Don't have a account? SignUp"),
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
