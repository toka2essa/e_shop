import 'package:flutter/material.dart';

class SplashHeaderText extends StatelessWidget {
  const SplashHeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'E-Shop',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Welcome! We\'re Glad To Have You With Us.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
