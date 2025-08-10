// lib/src/screens/parent/tabs/uang_saku_tab.dart (NEW FILE)
import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/helpers.dart';

class UangSakuTab extends StatelessWidget {
  const UangSakuTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      child: Column(
        children: [
          _buildCreateAllowanceCard(),
          Helpers.verticalSpace(AppConstants.spacing24),
          _buildAllowanceItem(
            name: 'Andi',
            amount: 10000,
            frequency: 'weekly',
            nextPayment: '2024-01-22',
          ),
          Helpers.verticalSpace(AppConstants.spacing16),
          _buildAllowanceItem(
            name: 'Sari',
            amount: 15000,
            frequency: 'weekly',
            nextPayment: '2024-01-22',
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAllowanceCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('+ Atur Uang Saku', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Tentukan uang saku rutin untuk anak', style: TextStyle(color: AppColors.grey600)),
            const Divider(height: 24),
            const TextField(decoration: InputDecoration(labelText: 'Pilih Anak')),
            Helpers.verticalSpace(AppConstants.spacing16),
            const TextField(decoration: InputDecoration(labelText: 'Jumlah (Rp)')),
            Helpers.verticalSpace(AppConstants.spacing16),
            const TextField(decoration: InputDecoration(labelText: 'Frekuensi', hintText: 'Mingguan')),
            Helpers.verticalSpace(AppConstants.spacing24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Atur Uang Saku'),
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

  Widget _buildAllowanceItem({
    required String name,
    required double amount,
    required String frequency,
    required String nextPayment,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(child: Text('💰')),
                Helpers.horizontalSpace(AppConstants.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Text('Uang saku weekly', style: TextStyle(color: AppColors.grey600, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                  ),
                  child: const Text('Aktif', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Jumlah per weekly', style: TextStyle(color: AppColors.grey600, fontSize: 12)),
                    Text(Helpers.formatCurrency(amount), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Pembayaran berikutnya', style: TextStyle(color: AppColors.grey600, fontSize: 12)),
                    Text(nextPayment, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ],
            ),
            Helpers.verticalSpace(AppConstants.spacing16),
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.edit, size: 16), label: const Text('Edit'))),
                Helpers.horizontalSpace(AppConstants.spacing12),
                Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.delete, size: 16), label: const Text('Hapus'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.error))),
              ],
            )
          ],
        ),
      ),
    );
  }
}