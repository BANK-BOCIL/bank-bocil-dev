// lib/src/screens/child/tingkat2_home_screen.dart
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../core/constants.dart';

class Tingkat2HomeScreen extends StatelessWidget {
  final User user;
  const Tingkat2HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return _Tier2Scaffold(
      title: 'Beranda Tingkat 2',
      child: Text('Halo, ${user.name} 👋', style: const TextStyle(fontSize: 20)),
    );
  }
  
  
}

class _Tier2Scaffold extends StatelessWidget {
  final String title;
  final Widget? child;
  const _Tier2Scaffold({required this.title, this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.tingkat2Primary,
        foregroundColor: Colors.white,
        title: Text(title),
        elevation: 0,
      ),
      body: Center(
        child: child ??
            const Text('Coming soon...',
                style: TextStyle(fontSize: 16, color: AppColors.grey600)),
      ),
    );
  }
}
