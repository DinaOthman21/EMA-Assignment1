import 'package:flutter/material.dart';

class homeScreen extends StatelessWidget {
  const homeScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to HomeScreen!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/profile');
              },
              child: const Text('Go to Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
