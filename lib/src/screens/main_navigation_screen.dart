// lib/src/screens/main_navigation_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/app_provider.dart';
import '../core/constants.dart';
// import 'child/tingkat1_home_screen.dart';
// import 'child/tingkat1_savings_screen.dart';
// import 'child/tingkat1_missions_screen.dart';
// import 'child/tingkat1_profile_screen.dart';
import 'parent/parent_main_screen.dart';

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
        final pages = _getPages(appProvider.currentTheme);
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

  List<Widget> _getPages(ThemeColor theme) {
    if (widget.user.type == UserType.parent) {
      return [
        ParentMainScreen(user: widget.user),
        // Halaman placeholder orang tua
        _buildPlaceholderPage('Anak-anak', AppColors.parentPrimary),
        _buildPlaceholderPage('Transaksi', AppColors.parentPrimary),
        _buildPlaceholderPage('Laporan', AppColors.parentPrimary),
        _buildPlaceholderPage('Profil', AppColors.parentPrimary),
      ];
    } else {
      switch (widget.user.ageTier) {
        case AgeTier.tingkat1:
          return [
            // Tingkat1HomeScreen(
            //   user: widget.user,
            //   onTabChange: (index) => setState(() => _currentIndex = index),
            // ),
            // Tingkat1SavingsScreen(user: widget.user),
            // Tingkat1MissionsScreen(user: widget.user),
            // Tingkat1ProfileScreen(user: widget.user),
            _buildPlaceholderPage(
                'Beranda Tingkat 1', AppColors.tingkat1Primary),
          ];
        case AgeTier.tingkat2:
          return [
            _buildPlaceholderPage(
                'Beranda Tingkat 2', AppColors.tingkat2Primary),
            _buildPlaceholderPage(
                'Celengan Tingkat 2', AppColors.tingkat2Primary),
            _buildPlaceholderPage('Misi Tingkat 2', AppColors.tingkat2Primary),
            _buildPlaceholderPage(
                'Transaksi Tingkat 2', AppColors.tingkat2Primary),
            _buildPlaceholderPage(
                'Profil Tingkat 2', AppColors.tingkat2Primary),
          ];
        case AgeTier.tingkat3:
          return [
            _buildPlaceholderPage(
                'Beranda Tingkat 3', AppColors.tingkat3Primary),
            _buildPlaceholderPage(
                'Budget Tingkat 3', AppColors.tingkat3Primary),
            _buildPlaceholderPage(
                'Investasi Tingkat 3', AppColors.tingkat3Primary),
            _buildPlaceholderPage(
                'Transaksi Tingkat 3', AppColors.tingkat3Primary),
            _buildPlaceholderPage(
                'Profil Tingkat 3', AppColors.tingkat3Primary),
          ];
        default:
          return [
            _buildPlaceholderPage('Error', AppColors.error),
          ];
      }
    }
  }

  List<BottomNavigationBarItem> _getBottomNavItems() {
    if (widget.user.type == UserType.parent) {
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
      switch (widget.user.ageTier) {
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
        case AgeTier.tingkat3:
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
        default:
          return [
            const BottomNavigationBarItem(
              icon: Icon(Icons.error_outline),
              activeIcon: Icon(Icons.error),
              label: 'Unknown',
            ),
          ];
      }
    }
  }

  Color _getPrimaryColor(ThemeColor theme) {
    if (widget.user.type == UserType.parent) {
      return AppColors.parentPrimary;
    } else {
      switch (widget.user.ageTier) {
        case AgeTier.tingkat1:
          return AppColors.getCurrentPrimary(theme);
        case AgeTier.tingkat2:
          return AppColors.tingkat2Primary;
        case AgeTier.tingkat3:
          return AppColors.tingkat3Primary;
        default:
          return AppColors.grey400;
      }
    }
  }

  Widget _buildPlaceholderPage(String title, Color color) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 40),
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
  }
}
