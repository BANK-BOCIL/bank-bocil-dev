// lib/src/screens/parent/parent_main_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_screen.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants.dart';
import '../../core/helpers.dart';

class ParentMainScreen extends StatelessWidget {
  const ParentMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard Orang Tua'),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            actions: [
              IconButton(
                onPressed: () async {
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const AuthScreen(),
                      ),
                      (Route<dynamic> route) =>
                          false, // Hapus semua rute sebelumnya
                    );
                  }
                },
                icon: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppConstants.spacing20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang, ${user?.name ?? 'Orang Tua'}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey800,
                  ),
                ),
                Helpers.verticalSpace(AppConstants.spacing16),

                // Child Code Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.spacing20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusLarge),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🔑 Kode untuk Anak',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey800,
                        ),
                      ),
                      Helpers.verticalSpace(AppConstants.spacing8),
                      Text(
                        'Berikan kode ini kepada anak untuk masuk ke aplikasi:',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey600,
                        ),
                      ),
                      Helpers.verticalSpace(AppConstants.spacing16),
                      Container(
                        padding: const EdgeInsets.all(AppConstants.spacing16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMedium),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Center(
                          child: Text(
                            user?.childCode ?? 'Loading...',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Helpers.verticalSpace(AppConstants.spacing24),

                // Info
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacing16),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      const Text('💡', style: TextStyle(fontSize: 24)),
                      Helpers.horizontalSpace(AppConstants.spacing12),
                      Expanded(
                        child: Text(
                          'Fitur lengkap untuk orang tua akan segera hadir. Saat ini Anda dapat memberikan kode di atas kepada anak untuk mulai belajar.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.grey700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// PERBAIKAN: Seluruh class _SliverTabBarDelegate dan method _buildStatCard
// yang tidak terpakai telah dihapus dari file ini untuk menjaga kebersihan kode.
