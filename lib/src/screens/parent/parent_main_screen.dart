// lib/src/screens/parent/parent_main_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_provider.dart';
import '../../core/constants.dart';
import '../../core/helpers.dart';
import '../auth_wrapper.dart';
import 'tabs/anak_tab.dart';
import 'tabs/tugas_tab.dart';
import 'tabs/uang_saku_tab.dart';
import 'tabs/pembelian_tab.dart';
import 'tabs/riwayat_tab.dart';
import 'tabs/analitik_tab.dart';

class ParentMainScreen extends StatefulWidget {
  const ParentMainScreen({super.key});

  @override
  State<ParentMainScreen> createState() => _ParentMainScreenState();
}

class _ParentMainScreenState extends State<ParentMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    // Start listening to Firestore-backed provider data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final user = auth.currentUser;
      if (user != null) {
        context.read<AppProvider>().listenToData(user);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const parentColor = AppColors.purplePrimary;
    final auth = context.watch<AuthProvider>();
    final app = context.watch<AppProvider>();

    // Derived, safe fallbacks
    final parent = auth.currentUser;
    final familyCode = parent?.childCode ?? '—';
    final childrenCount = app.children.length;
    final totalFamilyBalance = Helpers.formatCurrency(app.totalFamilyBalance);

    // If you later stream missions for parent, plug the real count here.
    const pendingTasksCount = 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(parentColor, parent?.name ?? 'Orang Tua'),
      body: app.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _HeaderStrip(
            chips: [
              '$childrenCount Anak',
              '$pendingTasksCount Tugas Aktif',
            ],
          ),
          _FamilyCodeCard(
            code: familyCode,
            onCopy: () async {
              if (familyCode == '—') return;
              await Clipboard.setData(ClipboardData(text: familyCode));
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kode keluarga disalin')),
              );
            },
          ),
          _StatsGrid(
            totalBalance: totalFamilyBalance,
            childrenCount: childrenCount,
            pendingTasks: pendingTasksCount,
          ),
          _buildTabBar(),
          Expanded(child: _buildTabBarView()),
        ],
      ),
    );
  }

  AppBar _buildAppBar(Color color, String name) {
    return AppBar(
      backgroundColor: color,
      foregroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 8,
      automaticallyImplyLeading: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard Keluarga',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(
            'Selamat datang, $name! ✨',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
      actionsIconTheme: const IconThemeData(size: 20, color: Colors.white),
      actions: [
        IconButton(
          tooltip: 'Keluar',
          onPressed: () async {
            final app = context.read<AppProvider>();
            final auth = context.read<AuthProvider>();
            app.clearDataOnLogout();
            await auth.logout();
            if (!mounted) return;
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const AuthWrapper()),
                  (_) => false,
            );
          },
          icon: const Icon(Icons.logout),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildTabBar() {
    return Material(
      color: Colors.transparent,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
        const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        tabs: const [
          Tab(text: 'Anak'),
          Tab(text: 'Tugas'),
          Tab(text: 'Uang Saku'),
          Tab(text: 'Pembelian'),
          Tab(text: 'Riwayat'),
          Tab(text: 'Analitik'),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: const [
        AnakTab(),
        TugasTab(),
        UangSakuTab(),
        PembelianTab(),
        RiwayatTab(),
        AnalitikTab(),
      ],
    );
  }
}

/// Chips under the app bar
class _HeaderStrip extends StatelessWidget {
  final List<String> chips;
  const _HeaderStrip({required this.chips});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: chips
            .map(
              (c) => Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.06),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              c,
              style: const TextStyle(fontSize: 11, color: Colors.black87),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}

/// Family Code card (now dynamic)
class _FamilyCodeCard extends StatelessWidget {
  final String code;
  final VoidCallback onCopy;
  const _FamilyCodeCard({required this.code, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    final border = Colors.black.withOpacity(0.08);
    final isEmpty = code.trim().isEmpty || code == '—';
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEAFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFB9A7FF).withOpacity(0.5)),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.qr_code_2, color: Color(0xFF7C4DFF)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Kode Keluarga',
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 2),
                  Text(
                    isEmpty ? 'Belum ada' : code,
                    style: const TextStyle(
                      fontSize: 18,
                      letterSpacing: 2.0,
                      fontFeatures: [FontFeature.tabularFigures()],
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: isEmpty ? null : onCopy,
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('Salin'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stats grid (dynamic)
class _StatsGrid extends StatelessWidget {
  final String totalBalance;
  final int childrenCount;
  final int pendingTasks;

  const _StatsGrid({
    required this.totalBalance,
    required this.childrenCount,
    required this.pendingTasks,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final aspect = width >= 900 ? 2.2 : width >= 600 ? 1.9 : 1.6;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: aspect,
      children: [
        const InfoStatCard(
          title: 'Total Saldo Keluarga',
          // value injected below using copy with simple const? We'll pass via ctor
          value: '',
          icon: Icons.account_balance_wallet_outlined,
          accentColor: AppColors.success,
        ).withValue(totalBalance),
        const InfoStatCard(
          title: 'Tugas Menunggu',
          value: '',
          icon: Icons.hourglass_top_outlined,
          accentColor: AppColors.warning,
        ).withValue('$pendingTasks'),
        const InfoStatCard(
          title: 'Anak Aktif',
          value: '',
          icon: Icons.person_outline,
          accentColor: AppColors.pinkPrimary,
        ).withValue('$childrenCount'),
        // You can add another dynamic card here later (e.g., total transaksi bulan ini)
        const InfoStatCard(
          title: '—',
          value: '',
          icon: Icons.trending_up,
          accentColor: AppColors.bluePrimary,
        ).withValue('—'),
      ],
    );
  }
}

class InfoStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  const InfoStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.black.withOpacity(0.06);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _IconPill(icon: icon, color: accentColor),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomLeft,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Tiny helper to keep the grid concise
extension _InfoStatCardValue on InfoStatCard {
  InfoStatCard withValue(String v) => InfoStatCard(
    title: title,
    value: v,
    icon: icon,
    accentColor: accentColor,
  );
}

class _IconPill extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _IconPill({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final bg = color.withOpacity(0.12);
    final fg = color.withOpacity(0.95);

    return Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 16, color: fg),
    );
  }
}
