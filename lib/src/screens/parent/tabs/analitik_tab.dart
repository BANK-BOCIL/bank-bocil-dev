// lib/src/screens/parent/tabs/analitik_tab.dart (NEW FILE)
import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/helpers.dart';

class AnalitikTab extends StatelessWidget {
  const AnalitikTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Performa Bulanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('Ringkasan aktivitas bulan ini', style: TextStyle(color: AppColors.grey600)),
          Helpers.verticalSpace(AppConstants.spacing16),
          _buildPerformanceCard(),
          Helpers.verticalSpace(AppConstants.spacing24),
          const Text('Insights Keterlibatan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('Analisis pola aktivitas anak', style: TextStyle(color: AppColors.grey600)),
          Helpers.verticalSpace(AppConstants.spacing16),
          _buildInsightCard(
            childName: 'Andi',
            level: 1,
            avgCompletion: '2.3 hari',
            lastActivity: '1 hari lalu',
            favCategory: 'Rumah tangga',
            engagementScore: 85,
          ),
          Helpers.verticalSpace(AppConstants.spacing16),
          _buildInsightCard(
            childName: 'Sari',
            level: 2,
            avgCompletion: '2.3 hari',
            lastActivity: '1 hari lalu',
            favCategory: 'Rumah tangga',
            engagementScore: 85,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _StatItem(title: 'Total Tugas', value: '1')),
                Expanded(child: _StatItem(title: 'Completion Rate', value: '33%', color: AppColors.success)),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Expanded(flex: 2, child: Text('Andi', style: TextStyle(fontWeight: FontWeight.bold))),
                const Expanded(flex: 3, child: Text('12 tugas selesai')),
              ],
            ),
            Helpers.verticalSpace(AppConstants.spacing8),
            Row(
              children: [
                const Expanded(flex: 2, child: Text('Sari', style: TextStyle(fontWeight: FontWeight.bold))),
                const Expanded(flex: 3, child: Text('18 tugas selesai')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard({
    required String childName,
    required int level,
    required String avgCompletion,
    required String lastActivity,
    required String favCategory,
    required int engagementScore,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(childName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Level $level', style: const TextStyle(color: AppColors.grey600, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            _StatItem(title: 'Rata-rata completion', value: avgCompletion),
            Helpers.verticalSpace(AppConstants.spacing12),
            _StatItem(title: 'Aktivitas terakhir', value: lastActivity),
            Helpers.verticalSpace(AppConstants.spacing12),
            _StatItem(title: 'Kategori favorit', value: favCategory),
            Helpers.verticalSpace(AppConstants.spacing12),
            _StatItem(title: 'Engagement score', value: '$engagementScore%', color: AppColors.success),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;

  const _StatItem({required this.title, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: AppColors.grey600)),
        Helpers.verticalSpace(AppConstants.spacing4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color ?? AppColors.grey800)),
      ],
    );
  }
}