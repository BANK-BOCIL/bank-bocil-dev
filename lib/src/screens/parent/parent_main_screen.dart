// lib/src/screens/parent/parent_main_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_provider.dart';
import '../../core/constants.dart';
import '../../core/helpers.dart';
import '../auth_wrapper.dart';
import '../assistant/ai_assistant_screen.dart'; // <-- NEW
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUser != null) {
        Provider.of<AppProvider>(context, listen: false)
            .listenToData(authProvider.currentUser!);
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
    const Color parentColor = AppColors.purplePrimary;
    final authProvider = Provider.of<AuthProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, authProvider, parentColor),
      floatingActionButton: _AssistantFab(onTap: _openAssistant), // <-- NEW
      body: appProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _HeaderStrip(chips: const ['2 Anak', '1 Tugas Menunggu']),
          _AssistantBanner(onTap: _openAssistant), // <-- NEW
          _StatsGrid(),
          _buildTabBar(),
          Expanded(child: _buildTabBarView()),
        ],
      ),
    );
  }

  void _openAssistant() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AIAssistantScreen(),
        settings: const RouteSettings(name: 'ai-assistant'),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, AuthProvider authProvider, Color color) {
    final user = authProvider.currentUser;

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
            'Selamat datang, ${user?.name ?? 'Orang Tua'}! ✨',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
      actionsIconTheme: const IconThemeData(size: 20, color: Colors.white),
      actions: [
        IconButton(
          tooltip: 'Komunikasi',
          onPressed: _openAssistant, // quick shortcut
          icon: const Icon(Icons.message_outlined),
        ),
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

/// Compact chips under the app bar
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
            child: Text(c,
                style:
                const TextStyle(fontSize: 11, color: Colors.black87)),
          ),
        )
            .toList(),
      ),
    );
  }
}

/// Gradient banner CTA to open the assistant
class _AssistantBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _AssistantBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF7C4DFF), Color(0xFF00BCD4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: const [
              _AssistantAvatar(),
              SizedBox(width: 12),
              Expanded(
                child: Hero(
                  tag: 'ai-assistant-title',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'AI Assistant: ringkas pengeluaran, buat misi, dan rencana uang saku otomatis.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssistantAvatar extends StatelessWidget {
  const _AssistantAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.28)),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.smart_toy_outlined, color: Colors.white),
    );
  }
}

/// Floating FAB with Hero to the assistant page
class _AssistantFab extends StatelessWidget {
  final VoidCallback onTap;
  const _AssistantFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'ai-fab', // or set to null to disable Hero entirely
      onPressed: onTap,
      icon: const Icon(Icons.smart_toy_outlined),
      label: const Text('AI Assistant'),
    );
  }
}


/// Cleaner stats: neutral cards with colored icon pills (unchanged)
class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

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
      children: const [
        InfoStatCard(
          title: 'Total Saldo Keluarga',
          value: 'Rp 70.000',
          icon: Icons.account_balance_wallet_outlined,
          accentColor: AppColors.success,
        ),
        InfoStatCard(
          title: 'Total Penghasilan',
          value: 'Rp 130.000',
          icon: Icons.trending_up,
          accentColor: AppColors.bluePrimary,
        ),
        InfoStatCard(
          title: 'Tugas Menunggu',
          value: '1',
          icon: Icons.hourglass_top_outlined,
          accentColor: AppColors.warning,
        ),
        InfoStatCard(
          title: 'Anak Aktif',
          value: '2',
          icon: Icons.person_outline,
          accentColor: AppColors.pinkPrimary,
        ),
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
