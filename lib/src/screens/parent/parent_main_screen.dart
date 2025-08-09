// lib/src/screens/parent/parent_main_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/app_provider.dart';
import '../../core/constants.dart';
import '../../core/helpers.dart';

class ParentMainScreen extends StatelessWidget {
  final User user;

  const ParentMainScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Dashboard Keluarga',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.parentPrimary,
                    ),
                  ),
                  Helpers.verticalSpace(AppConstants.spacing8),
                  Text(
                    'Selamat datang, ${user.name}!',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.grey600,
                    ),
                  ),
                  Helpers.verticalSpace(AppConstants.spacing24),

                  // Contoh Placeholder untuk Total Saldo
                  _buildStatCard(
                    title: 'Total Saldo Keluarga',
                    value: 'Rp 70,000',
                    color: AppColors.success,
                    icon: Icons.account_balance_wallet,
                  ),

                  Helpers.verticalSpace(AppConstants.spacing16),

                  // Contoh Placeholder untuk Tugas Menunggu
                  _buildStatCard(
                    title: 'Tugas Menunggu',
                    value: '1 Tugas',
                    color: AppColors.warning,
                    icon: Icons.assignment,
                  ),

                  Helpers.verticalSpace(AppConstants.spacing16),

                  // Contoh Placeholder untuk Anak Aktif
                  _buildStatCard(
                    title: 'Anak Aktif',
                    value: '2 Anak',
                    color: AppColors.tingkat1Primary,
                    icon: Icons.child_care,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          Helpers.horizontalSpace(AppConstants.spacing16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey800,
                ),
              ),
              Helpers.verticalSpace(AppConstants.spacing4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
