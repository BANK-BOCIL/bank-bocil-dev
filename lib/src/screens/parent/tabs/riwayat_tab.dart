// lib/src/screens/parent/tabs/riwayat_tab.dart (NEW FILE)
import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/helpers.dart';

class RiwayatTab extends StatelessWidget {
  const RiwayatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      children: [
        const Text('Riwayat Aktivitas Keluarga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('Semua aktivitas keuangan keluarga dalam satu tempat', style: TextStyle(color: AppColors.grey600)),
        Helpers.verticalSpace(AppConstants.spacing16),
        _buildHistoryItem(
          icon: Icons.check_circle,
          color: AppColors.success,
          title: "Tugas 'Merapikan kamar' disetujui",
          subtitle: 'Andi (Level 1) • 2024-01-15 14:30 • Task Approval',
          amount: 5000,
          isIncome: true,
        ),
        _buildHistoryItem(
          icon: Icons.shopping_cart,
          color: AppColors.error,
          title: 'Pembelian QRIS di Toko Mainan Bahagia',
          subtitle: 'Andi (Level 1) • 2024-01-15 14:30 • Purchase',
          amount: 15000,
          isIncome: false,
        ),
        _buildHistoryItem(
          icon: Icons.card_giftcard,
          color: AppColors.info,
          title: 'Uang saku mingguan',
          subtitle: 'Sari (Level 2) • 2024-01-13 08:00 • Allowance',
          amount: 15000,
          isIncome: true,
        ),
        _buildHistoryItem(
          icon: Icons.savings,
          color: AppColors.purplePrimary,
          title: 'Menabung untuk laptop baru',
          subtitle: 'Sari (Level 2) • 2024-01-12 19:20 • Savings',
          amount: 20000,
          isIncome: false,
        ),
      ],
    );
  }

  Widget _buildHistoryItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required double amount,
    required bool isIncome,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: AppConstants.spacing12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        side: BorderSide(color: color, width: 2),
      ),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: Text(
          '${isIncome ? '+' : '-'}${Helpers.formatCurrency(amount)}',
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}