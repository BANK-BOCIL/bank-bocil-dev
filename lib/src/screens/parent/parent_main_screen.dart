import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui'; // For ImageFilter
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants.dart';
import '../../core/helpers.dart';
import '../child/auth_screen.dart';

// --- Temporary Data Wrapper (Good Practice!) ---
// This class combines your User model with the financial data needed for this specific screen.
// In a real app, you'd build this object by fetching data from your 'users' and 'accounts' collections in Firebase.
class ChildDashboardInfo {
  final User user; // Your existing User model
  final double balance;
  final double totalEarned;
  final int tasksCompleted;
  final int tasksPending;
  final int goalsActive;
  final String status; // e.g., 'Pemula', 'Mandiri'

  ChildDashboardInfo({
    required this.user,
    required this.balance,
    required this.totalEarned,
    required this.tasksCompleted,
    required this.tasksPending,
    required this.goalsActive,
    required this.status,
  });
}
// --- End of Temporary Data Wrapper ---

class ParentMainScreen extends StatefulWidget {
  const ParentMainScreen({super.key});

  @override
  State<ParentMainScreen> createState() => _ParentMainScreenState();
}

class _ParentMainScreenState extends State<ParentMainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- Mock Data Source (Now using your User model) ---
  // In a real app, this would come from a provider that fetches and combines data.
  final double _totalFamilyBalance = 70000;
  final double _totalFamilyIncome = 130000;
  final int _pendingTasks = 1;

  final List<ChildDashboardInfo> _childrenData = [
    ChildDashboardInfo(
      user: User(
        id: 'child1',
        name: 'Andi',
        type: UserType.child,
        age: 8,
        ageTier: AgeTier.tingkat1,
        parentId: 'parent1',
        createdAt: DateTime.now(),
      ),
      balance: 25000,
      totalEarned: 50000,
      tasksCompleted: 12,
      tasksPending: 2,
      goalsActive: 2,
      status: 'Pemula',
    ),
    ChildDashboardInfo(
      user: User(
        id: 'child2',
        name: 'Bunga',
        type: UserType.child,
        age: 10,
        ageTier: AgeTier.tingkat2,
        parentId: 'parent1',
        createdAt: DateTime.now(),
      ),
      balance: 45000,
      totalEarned: 80000,
      tasksCompleted: 8,
      tasksPending: 0,
      goalsActive: 3,
      status: 'Mandiri',
    ),
  ];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color parentColor = AppColors.purplePrimary;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, parentColor),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(child: _buildHeaderStats()),
            SliverPersistentHeader(
              delegate: _SliverTabBarDelegate(_buildTabBar()),
              pinned: true,
            ),
          ];
        },
        body: _buildTabBarView(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Color color) {
    // NOTE: Your AuthProvider should provide a User object, not a custom one.
    // I'm assuming authProvider.currentUser is of type User.
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard Keluarga'),
          Helpers.verticalSpace(AppConstants.spacing4),
          Text(
            'Selamat datang, ${user?.name ?? 'Budi Santoso'}! ✨',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
          ),
        ],
      ),
      backgroundColor: color,
      foregroundColor: AppColors.white,
      actions: [
        IconButton(
          onPressed: () {
            // TODO: Implement filter functionality
          },
          icon: const Icon(Icons.filter_list),
        ),
        IconButton(
          onPressed: () async {
            await Provider.of<AuthProvider>(context, listen: false).logout();
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            }
          },
          icon: const Icon(Icons.exit_to_app),
        ),
      ],
    );
  }

  Widget _buildHeaderStats() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      child: Column(
        children: [
          StatCard(
            title: 'Total Saldo Keluarga',
            value: Helpers.formatCurrency(_totalFamilyBalance),
            icon: Icons.account_balance_wallet_outlined,
            gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF06D6A0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          Helpers.verticalSpace(AppConstants.spacing12),
          StatCard(
            title: 'Total Penghasilan',
            value: Helpers.formatCurrency(_totalFamilyIncome),
            icon: Icons.trending_up_outlined,
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          Helpers.verticalSpace(AppConstants.spacing12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Tugas Menunggu',
                  value: _pendingTasks.toString(),
                  icon: Icons.hourglass_top_outlined,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  isSmall: true,
                ),
              ),
              Helpers.horizontalSpace(AppConstants.spacing12),
              Expanded(
                child: StatCard(
                  title: 'Anak Aktif',
                  value: _childrenData.length.toString(),
                  icon: Icons.person_outline,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  isSmall: true,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // --- FIX: Return PreferredSizeWidget ---
  PreferredSizeWidget _buildTabBar() {
    // Wrap the TabBar in a PreferredSize widget to give it a specific height,
    // which is required by the SliverPersistentHeaderDelegate.
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight), // Standard toolbar height
      child: Container(
        color: AppColors.background,
        child: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey500,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(icon: Icon(Icons.people_alt_outlined), text: 'Anak'),
            Tab(icon: Icon(Icons.list_alt_outlined), text: 'Tugas'),
            Tab(icon: Icon(Icons.savings_outlined), text: 'Tujuan'),
            Tab(icon: Icon(Icons.qr_code), text: 'Kode'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        // --- Anak Tab ---
        ListView.builder(
          padding: const EdgeInsets.all(AppConstants.spacing16),
          itemCount: _childrenData.length,
          itemBuilder: (context, index) {
            return ChildInfoCard(childInfo: _childrenData[index]);
          },
        ),
        // --- Other Tabs (Placeholder) ---
        const Center(child: Text('Halaman Tugas akan segera hadir!')),
        const Center(child: Text('Halaman Tujuan akan segera hadir!')),
        _buildChildCodeView(),
      ],
    );
  }

  Widget _buildChildCodeView() {
    // NOTE: The user model doesn't have a 'childCode'. You'll need to decide
    // how to generate/store this. For now, we'll use a placeholder.
    final user = Provider.of<AuthProvider>(context).currentUser;
    final childCode = user?.id.substring(0, 6).toUpperCase() ?? 'MEMUAT...';

    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacing20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Kode untuk Anak',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.grey800,
            ),
          ),
          Helpers.verticalSpace(AppConstants.spacing8),
          Text(
            'Berikan kode ini kepada anak untuk masuk ke aplikasi:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.grey600,
            ),
          ),
          Helpers.verticalSpace(AppConstants.spacing20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                BorderRadius.circular(AppConstants.radiusMedium),
                border: Border.all(color: AppColors.primary, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
            ),
            child: Text(
              childCode,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Reusable Widgets (Updated to use new data models) ---

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Gradient gradient;
  final bool isSmall;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isSmall ? AppConstants.spacing12 : AppConstants.spacing16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isSmall ? _buildSmallLayout() : _buildLargeLayout(),
    );
  }

  Widget _buildLargeLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),
            ),
            Helpers.verticalSpace(AppConstants.spacing4),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Icon(icon, color: AppColors.white.withOpacity(0.8), size: 36),
      ],
    );
  }

  Widget _buildSmallLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: AppColors.white, fontSize: 14),
            ),
            Icon(icon, color: AppColors.white.withOpacity(0.8), size: 24),
          ],
        ),
        Helpers.verticalSpace(AppConstants.spacing4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ChildInfoCard extends StatelessWidget {
  final ChildDashboardInfo childInfo;
  const ChildInfoCard({super.key, required this.childInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: AppConstants.spacing16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      shadowColor: AppColors.grey200,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          children: [
            _buildChildHeader(),
            const Divider(height: AppConstants.spacing32),
            _buildChildStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildChildHeader() {
    // A simple emoji for the avatar, you can replace with childInfo.user.profileImageUrl
    final String avatarEmoji = childInfo.user.age! < 10 ? '👦' : '👧';
    final String childCode = childInfo.user.name.toUpperCase().substring(0,4) + childInfo.user.age.toString();

    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(avatarEmoji, style: const TextStyle(fontSize: 28)),
        ),
        Helpers.horizontalSpace(AppConstants.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                childInfo.user.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey800,
                ),
              ),
              Helpers.verticalSpace(AppConstants.spacing4),
              Text(
                '${childInfo.user.age} tahun • Level ${childInfo.user.ageTier?.name.replaceAll('tingkat', '')} • Kode: $childCode',
                style: const TextStyle(fontSize: 12, color: AppColors.grey500),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
          ),
          child: Text(
            childInfo.status,
            style: const TextStyle(
              color: AppColors.warning,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChildStats() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _StatItem(label: 'Saldo', value: 'Rp ${Helpers.formatCurrency(childInfo.balance)}', color: AppColors.success)),
            Expanded(child: _StatItem(label: 'Total Earned', value: 'Rp ${Helpers.formatCurrency(childInfo.totalEarned)}', color: AppColors.primary)),
          ],
        ),
        Helpers.verticalSpace(AppConstants.spacing16),
        Row(
          children: [
            Expanded(child: _StatItem(label: 'Tugas Selesai', value: childInfo.tasksCompleted.toString())),
            Expanded(child: _StatItem(label: 'Tugas Pending', value: childInfo.tasksPending.toString())),
            Expanded(child: _StatItem(label: 'Target Aktif', value: childInfo.goalsActive.toString())),
          ],
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatItem({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.grey500),
        ),
        Helpers.verticalSpace(AppConstants.spacing4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.grey800,
          ),
        ),
      ],
    );
  }
}

// --- FIX: Delegate now accepts a PreferredSizeWidget ---
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: 2.0,
      shadowColor: AppColors.grey200,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
