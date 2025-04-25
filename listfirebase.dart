import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class User {
  final String email;
  final String password;

  User({required this.email, required this.password});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Auth Demo',
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  List<User> _users = []; // Local list of users
  bool isLogin = true;

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage("Please enter both email and password");
      return;
    }

    if (isLogin) {
      final user = _users.firstWhere(
            (u) => u.email == email && u.password == password,
        orElse: () => User(email: '', password: ''),
      );

      if (user.email.isNotEmpty) {
        _showMessage("Login successful!");
      } else {
        _showMessage("Invalid credentials");
      }
    } else {
      final exists = _users.any((u) => u.email == email);
      if (exists) {
        _showMessage("User already exists!");
      } else {
        setState(() {
          _users.add(User(email: email, password: password));
        });
        _showMessage("Signed up successfully!");
      }
    }

    _emailController.clear();
    _passwordController.clear();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(isLogin ? 'Login' : 'Sign Up'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin ? 'Need an account? Sign Up' : 'Have an account? Login'),
            )
          ],
        ),
      ),
    );
  }
}
