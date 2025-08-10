// lib/src/screens/parent/tabs/tugas_tab.dart (NEW FILE)
import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/helpers.dart';

class TugasTab extends StatelessWidget {
  const TugasTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCreateTaskCard(),
          Helpers.verticalSpace(AppConstants.spacing24),
          _buildTaskItem(
            context,
            icon: '⌛',
            title: 'Merapikan kamar',
            childName: 'Andi',
            category: 'household',
            date: '2024-01-15',
            description: 'Rapikan tempat tidur dan mainan',
            reward: 5000,
            status: 'Menunggu',
          ),
          Helpers.verticalSpace(AppConstants.spacing16),
          _buildTaskItem(
            context,
            icon: '✅',
            title: 'Membantu cuci piring',
            childName: 'Sari',
            category: 'household',
            date: '2024-01-14',
            description: 'Bantu mama cuci piring setelah makan',
            reward: 3000,
            status: 'Selesai',
          ),
          Helpers.verticalSpace(AppConstants.spacing16),
          _buildTaskItem(
            context,
            icon: '📚',
            title: 'Belajar matematika',
            childName: 'Andi',
            category: 'education',
            date: '2024-01-15',
            description: 'Selesaikan PR matematika',
            reward: 8000,
            status: 'Aktif',
          ),
        ],
      ),
    );
  }

  Widget _buildCreateTaskCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('+ Buat Tugas Baru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Berikan tugas kepada anak dan tentukan reward', style: TextStyle(color: AppColors.grey600)),
            const Divider(height: 24),
            const TextField(decoration: InputDecoration(labelText: 'Pilih Anak')),
            Helpers.verticalSpace(AppConstants.spacing16),
            const TextField(decoration: InputDecoration(labelText: 'Judul Tugas', hintText: 'Contoh: Merapikan kamar')),
            Helpers.verticalSpace(AppConstants.spacing16),
            const TextField(decoration: InputDecoration(labelText: 'Deskripsi')),
            Helpers.verticalSpace(AppConstants.spacing16),
            const TextField(decoration: InputDecoration(labelText: 'Reward (Rp)')),
            Helpers.verticalSpace(AppConstants.spacing24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Buat Tugas'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.grey800,
                  foregroundColor: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, {
    required String icon,
    required String title,
    required String childName,
    required String category,
    required String date,
    required String description,
    required double reward,
    required String status,
  }) {
    Color statusColor;
    switch (status) {
      case 'Menunggu':
        statusColor = AppColors.warning;
        break;
      case 'Selesai':
        statusColor = AppColors.success;
        break;
      default:
        statusColor = AppColors.info;
    }

    return Card(
      elevation: 2,
      color: statusColor.withOpacity(0.05),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          side: BorderSide(color: statusColor.withOpacity(0.5))
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 24)),
                Helpers.horizontalSpace(AppConstants.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('$childName • $category • Dibuat: $date', style: const TextStyle(color: AppColors.grey600, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                  ),
                  child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                Helpers.horizontalSpace(AppConstants.spacing8),
                Text(Helpers.formatCurrency(reward), style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            Text(description, style: const TextStyle(color: AppColors.grey700)),
            if (status == 'Menunggu') ...[
              Helpers.verticalSpace(AppConstants.spacing16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check),
                      label: const Text('Setujui'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                    ),
                  ),
                  Helpers.horizontalSpace(AppConstants.spacing12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.close),
                      label: const Text('Tolak'),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                    ),
                  ),
                ],
              )
            ] else if (status == 'Selesai') ...[
              Helpers.verticalSpace(AppConstants.spacing12),
              Text('✅ Diselesaikan pada 2024-01-14 • Reward Rp 3,000 telah ditambahkan', style: TextStyle(color: AppColors.success, fontSize: 12)),
            ]
          ],
        ),
      ),
    );
  }
}