import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.greenAccent,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome Home!',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Login Successful',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
