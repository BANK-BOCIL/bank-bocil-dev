// lib/src/screens/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/app_provider.dart';
import 'auth/auth_screen.dart';
import 'main_navigation_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) {
        if (auth.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final user = auth.currentUser;
        return user != null
            ? MainNavigationScreen(user: user)
            : const AuthScreen();
      },
    );
  }
}


