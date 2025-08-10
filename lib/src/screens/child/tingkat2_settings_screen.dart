import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../core/constants.dart';
import '../../core/helpers.dart';
import '../../providers/auth_provider.dart';
import '../auth/auth_screen.dart';

class Tingkat2SettingsScreen extends StatelessWidget {
  final User user;
  const Tingkat2SettingsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.tingkat2Primary,
        foregroundColor: Colors.white,
        title: const Text('Pengaturan'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        children: [
          // Account card
          Container(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.tingkat2Primary.withOpacity(.12),
                  child: Text(
                    (user.name.isNotEmpty ? user.name[0].toUpperCase() : '👤'),
                    style: const TextStyle(fontSize: 20, color: AppColors.grey800),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('Usia ${user.age} • Tingkat 2',
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.grey600)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Help
          _SettingTile(
            icon: Icons.help_outline,
            title: 'Bantuan',
            subtitle: 'Pertanyaan & dukungan',
            onTap: () => Helpers.showSnackBar(
              context,
              'Pusat bantuan segera hadir 👋',
            ),
          ),

          // About
          _SettingTile(
            icon: Icons.info_outline,
            title: 'Tentang Aplikasi',
            subtitle: 'Informasi Bank Bocil',
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Bank Bocil',
              applicationVersion: AppConstants.appVersion,
              children: const [
                Text('Aplikasi edukasi keuangan untuk anak.'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Logout button
          ElevatedButton.icon(
            onPressed: () => _confirmLogout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(vertical: AppConstants.spacing16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Keluar dari Akun'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(AppConstants.spacing20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusLarge),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300, borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Keluar dari akun?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text(
              'Kamu perlu masuk lagi untuk menggunakan aplikasi.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final auth = Provider.of<AuthProvider>(context, listen: false);
                      await auth.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const AuthScreen()),
                              (_) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Keluar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacing12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.tingkat2Primary),
        title: Text(title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.grey800)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.grey600)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.grey400),
        onTap: onTap,
      ),
    );
  }
}
