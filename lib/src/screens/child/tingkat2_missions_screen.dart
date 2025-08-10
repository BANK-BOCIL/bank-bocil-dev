// lib/src/screens/child/tingkat2_missions_screen.dart
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../core/constants.dart';

class Tingkat2MissionsScreen extends StatelessWidget {
  final User user;
  const Tingkat2MissionsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return const _Tier2Scaffold(title: 'Misi Tingkat 2');
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