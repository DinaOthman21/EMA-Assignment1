import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:assignment1/services/DatabaseHelper.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add email validation here
                  // Example validation for FCI email structure
                  if (!value.endsWith('@stud.fci-cu.edu.eg')) {
                    return 'Email must be in the format studentID@stud.fci-cu.edu.eg';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Fetch user from the database using entered email
                    DatabaseHelper.getUserByEmail(_emailController.text)
                        .then((user) {
                      if (user != null &&
                          user.password == _passwordController.text) {
                        // Login successful

                        if (kDebugMode) {
                          print(user);
                          print('Login success');
                        }

                        // Navigate to the home screen
                        Navigator.pushNamed(context, '/home', arguments: user);
                      } else {
                        // Login failed
                        if (kDebugMode) {
                          print(user);
                          print('Login failure');
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Invalid email or password. Please try again.'),
                          ),
                        );
                      }
                    });
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
