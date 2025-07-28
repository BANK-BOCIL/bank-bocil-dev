import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/app_provider.dart';
import '../core/constants.dart';
import 'child/tingkat1_home_screen.dart';
import 'child/tingkat1_savings_screen.dart';
import 'child/tingkat1_missions_screen.dart';
import 'child/tingkat1_profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final User user;

  const MainNavigationScreen({
    super.key,
    required this.user,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final pages = _getPages();
        final bottomNavItems = _getBottomNavItems();

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.white,
              selectedItemColor: _getPrimaryColor(appProvider.currentTheme),
              unselectedItemColor: AppColors.grey400,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              items: bottomNavItems,
            ),
          ),
        );
      },
    );
  }

  List<Widget> _getPages() {
    if (widget.user.isParent) {
      return [
        _buildPlaceholderPage('Dashboard Orang Tua'),
        _buildPlaceholderPage('Anak-anak'),
        _buildPlaceholderPage('Transaksi'),
        _buildPlaceholderPage('Laporan'),
        _buildPlaceholderPage('Profil'),
      ];
    } else {
      // Child pages based on age tier
      switch (widget.user.ageTier!) {
        case AgeTier.tingkat1:
          return [
            Tingkat1HomeScreen(
              user: widget.user,
              onTabChange: (index) => setState(() => _currentIndex = index),
            ),
            Tingkat1SavingsScreen(user: widget.user),
            Tingkat1MissionsScreen(user: widget.user),
            Tingkat1ProfileScreen(user: widget.user),
          ];
        case AgeTier.tingkat2:
          return [
            _buildPlaceholderPage('Beranda'),
            _buildPlaceholderPage('Celengan'),
            _buildPlaceholderPage('Misi'),
            _buildPlaceholderPage('Transaksi'),
            _buildPlaceholderPage('Profil'),
          ];
        case AgeTier.tingkat3:
          return [
            _buildPlaceholderPage('Beranda'),
            _buildPlaceholderPage('Budget'),
            _buildPlaceholderPage('Investasi'),
            _buildPlaceholderPage('Transaksi'),
            _buildPlaceholderPage('Profil'),
          ];
      }
    }
  }

  List<BottomNavigationBarItem> _getBottomNavItems() {
    if (widget.user.isParent) {
      return [
        const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.child_care_outlined),
          activeIcon: Icon(Icons.child_care),
          label: 'Anak',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          activeIcon: Icon(Icons.receipt_long),
          label: 'Transaksi',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          activeIcon: Icon(Icons.analytics),
          label: 'Laporan',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ];
    } else {
      switch (widget.user.ageTier!) {
        case AgeTier.tingkat1:
          return [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.savings_outlined),
              activeIcon: Icon(Icons.savings),
              label: 'Celengan',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: 'Misi',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ];
        case AgeTier.tingkat2:
          return [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.savings_outlined),
              activeIcon: Icon(Icons.savings),
              label: 'Celengan',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: 'Misi',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Transaksi',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ];
        case AgeTier.tingkat3:
          return [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'Budget',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_outlined),
              activeIcon: Icon(Icons.trending_up),
              label: 'Investasi',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Transaksi',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ];
      }
    }
  }

  Color _getPrimaryColor(ThemeColor theme) {
    if (widget.user.isParent) {
      return AppColors.parentPrimary;
    } else {
      switch (widget.user.ageTier!) {
        case AgeTier.tingkat1:
          return AppColors.getCurrentPrimary(theme);
        case AgeTier.tingkat2:
          return AppColors.tingkat2Primary;
        case AgeTier.tingkat3:
          return AppColors.tingkat3Primary;
      }
    }
  }

  Widget _buildPlaceholderPage(String title) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Custom Header
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _getPrimaryColor(appProvider.currentTheme),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Placeholder Content
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.construction,
                            size: 64,
                            color: AppColors.grey400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '$title Screen',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.grey600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Coming soon...',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.grey500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
