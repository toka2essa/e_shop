import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LogoCard extends StatelessWidget {
  const LogoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(28),
      ),
      child: Center(
        child: Image.asset(
          'assets/splash.png',
          width: 140,
          height: 140,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
