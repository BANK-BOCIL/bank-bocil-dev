// lib/src/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// PERBAIKAN: Menggunakan path yang benar (satu level ke atas dari folder 'screens')
import '../providers/auth_provider.dart';
import '../models/user.dart';
import '../core/constants.dart';

// Impor lain yang sudah ada (path ini sudah benar karena berada dalam folder 'screens' yang sama atau di bawahnya)
import 'main_navigation_screen.dart';
import 'auth/auth_screen.dart';
import 'parent/parent_main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoScale;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.initialize();

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      final user = authProvider.currentUser!;
      if (user.type == UserType.parent) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ParentMainScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => MainNavigationScreen(user: user)),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tingkat1Primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _logoScale,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoScale.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🏦', style: TextStyle(fontSize: 60)),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            AnimatedBuilder(
              animation: _textOpacity,
              builder: (context, child) {
                return Opacity(
                  opacity: _textOpacity.value,
                  child: Column(
                    children: [
                      Text(
                        AppConstants.appName,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Belajar Menabung dengan Menyenangkan',
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 60),
            AnimatedBuilder(
              animation: _textOpacity,
              builder: (context, child) {
                return Opacity(
                  opacity: _textOpacity.value,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                    strokeWidth: 3,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
