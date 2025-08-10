// lib/src/screens/child/tingkat2_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helpers.dart';
import '../../models/user.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants.dart';
import '../auth_wrapper.dart';

class Tingkat2ProfileScreen extends StatelessWidget {
  final User user;
  const Tingkat2ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final auth = context.read<AuthProvider>();
    final balance = app.getBalance(user.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: AppColors.tingkat2Primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context, auth, app),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spacing16),
          children: [
            // HEADER CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                border: Border.all(color: Colors.black.withOpacity(0.06)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.tingkat2Primary.withOpacity(.15),
                    child: const Icon(Icons.person, color: AppColors.tingkat2Primary),
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
                        Text('Tingkat 2 • Umur ${user.age}',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.grey600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // BALANCE
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                border: Border.all(color: Colors.black.withOpacity(0.06)),
              ),
              child: Row(
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.tingkat2Primary.withOpacity(.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.account_balance_wallet_outlined),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Saldo Saya',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                  ),
                  Text(
                    Helpers.formatCurrency(balance),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // SETTINGS
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                border: Border.all(color: Colors.black.withOpacity(0.06)),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: app.isNotificationEnabled,
                    title: const Text('Notifikasi'),
                    subtitle: const Text('Aktifkan pemberitahuan'),
                    onChanged: (v) => app.toggleNotification(v),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Ganti Tema'),
                    subtitle: Text(app.currentTheme.name),
                    leading: const Icon(Icons.color_lens_outlined),
                    onTap: () => _showThemePicker(context, app),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // LOGOUT
            ElevatedButton.icon(
              onPressed: () => _confirmLogout(context, auth, app),
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemePicker(BuildContext context, AppProvider app) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        final themes = ThemeColor.values;
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: themes.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final t = themes[i];
              return ListTile(
                title: Text(t.name),
                trailing: app.currentTheme == t
                    ? const Icon(Icons.check, color: AppColors.tingkat2Primary)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  app.changeTheme(t);
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _confirmLogout(
      BuildContext context,
      AuthProvider auth,
      AppProvider app,
      ) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu bisa masuk lagi kapan saja.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (yes != true) return;

    app.clearDataOnLogout();
    await auth.logout();

    // Go back to the root auth screen
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
            (_) => false,
      );
    }
  }
}
