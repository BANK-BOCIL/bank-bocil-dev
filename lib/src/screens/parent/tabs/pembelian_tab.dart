// lib/src/screens/parent/tabs/pembelian_tab.dart (NEW FILE)
import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/helpers.dart';

class PembelianTab extends StatelessWidget {
  const PembelianTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      children: [
        const Text('Riwayat Pembelian QRIS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('Monitor semua pembelian yang dilakukan anak menggunakan QRIS', style: TextStyle(color: AppColors.grey600)),
        Helpers.verticalSpace(AppConstants.spacing16),
        _buildPurchaseItem(
          store: 'Toko Mainan Bahagia',
          childName: 'Andi',
          location: 'Mall Central Park',
          date: '2024-01-15',
          time: '14:30',
          amount: 15000,
        ),
        _buildPurchaseItem(
          store: 'Gramedia Bookstore',
          childName: 'Sari',
          location: '',
          date: '2024-01-14',
          time: '16:45',
          amount: 25000,
        ),
      ],
    );
  }

  Widget _buildPurchaseItem({
    required String store,
    required String childName,
    required String location,
    required String date,
    required String time,
    required double amount,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: AppConstants.spacing12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.storefront)),
        title: Text('$store ($childName)', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$date @ $time ${location.isNotEmpty ? '• $location' : ''}'),
        trailing: Text('-${Helpers.formatCurrency(amount)}', style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
      ),
    );
  }
}