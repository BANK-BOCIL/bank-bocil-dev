// lib\src\screens\splash_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants.dart';
import '../models/user.dart' as local_model;
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
    _initializeAppAndNavigate();
  }

  Future<void> _initializeAppAndNavigate() async {
    // Tunggu animasi splash screen selesai
    await Future.delayed(const Duration(milliseconds: 3000));

    if (!mounted) return;

    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      // Pengguna sudah login, ambil data tambahan dari Firestore
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (!mounted) return; // Cek mounted lagi setelah await

        if (userDoc.exists) {
          final userData = userDoc.data()!;
          final userTypeString = userData['role'] as String;
          final userType = userTypeString.contains('parent')
              ? local_model.UserType.parent
              : local_model.UserType.child;

          final localUser =
              local_model.User.fromFirestore(userData); // Buat objek User lokal

          if (userType == local_model.UserType.parent) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      ParentMainScreen(user: localUser)), // Teruskan localUser
            );
          } else if (userType == local_model.UserType.child) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => MainNavigationScreen(
                      user: localUser)), // Teruskan localUser
            );
          } else {
            // Role tidak dikenal, arahkan ke halaman otentikasi
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AuthScreen()),
            );
          }
        } else {
          // Data Firestore tidak ditemukan, arahkan ke halaman otentikasi
          // Ini bisa terjadi jika user terautentikasi tapi dokumen di Firestore hilang
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AuthScreen()),
          );
        }
      } catch (e) {
        // Tangani error saat mengambil data dari Firestore
        // Tambahkan print untuk melihat error di konsol
        debugPrint('Error fetching user data from Firestore: $e');
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AuthScreen()),
          );
        }
      }
    } else {
      // Pengguna belum login, arahkan ke halaman otentikasi
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
            // Logo Animation
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

            // App Title Animation
            AnimatedBuilder(
              animation: _textOpacity,
              builder: (context, child) {
                return Opacity(
                  opacity: _textOpacity.value,
                  child: Column(
                    children: [
                      Text(AppConstants.appName,
                          style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Belajar Menabung dengan Menyenangkan',
                          style: TextStyle(
                              color: AppColors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 60),

            // Loading Animation
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
