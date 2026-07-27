import 'package:flutter/material.dart';
import 'package:eshop_app/core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings', style: TextStyle(color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingItem(Icons.person_outline, 'Profile'),
          _buildSettingItem(Icons.notifications_none, 'Notifications'),
          _buildSettingItem(Icons.lock_outline, 'Privacy'),
          _buildSettingItem(Icons.help_outline, 'Help & Support'),
          _buildSettingItem(Icons.logout, 'Logout', color: Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title: Text(title, style: TextStyle(color: color ?? AppColors.textPrimary)),
      trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
      onTap: () {},
    );
  }
}
