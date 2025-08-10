// lib/src/screens/main_navigation_screen.dart
import 'package:bankbocil/src/screens/child/tingkat2_transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/app_provider.dart';
import '../core/constants.dart';

// TIER 1
import 'child/tingkat1_home_screen.dart';
import 'child/tingkat1_savings_screen.dart';
import 'child/tingkat1_missions_screen.dart';
import 'child/tingkat1_profile_screen.dart';
import 'child/tingkat2_profile_screen.dart';
import 'child/tingkat2_home_screen.dart';
import 'child/tingkat2_missions_screen.dart';
import 'child/tingkat2_savings_screen.dart';
import 'child/tingkat2_savings_screen.dart';
import 'child/tingkat2_settings_screen.dart';

// TIER 2 (use your real pages if you have them; placeholders otherwise)
import 'parent/parent_main_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final User user;

  const MainNavigationScreen({super.key, required this.user});

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
        final items = _getBottomNavItems();

        // Safety: keep index within range if pages/items change
        if (_currentIndex >= pages.length) {
          _currentIndex = pages.length - 1;
        }
        if (items.length != pages.length) {
          // If this ever happens, show a simple error page so it’s obvious
          return Scaffold(
            body: Center(
              child: Text(
                'Config mismatch: ${pages.length} pages vs ${items.length} tabs',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        return Scaffold(
          body: IndexedStack(index: _currentIndex, children: pages),
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
              onTap: (i) => setState(() => _currentIndex = i),
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.white,
              selectedItemColor: _getPrimaryColor(appProvider.currentTheme),
              unselectedItemColor: AppColors.grey400,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              items: items,
            ),
          ),
        );
      },
    );
  }

  List<Widget> _getPages(ThemeColor theme) {
    if (widget.user.type == UserType.parent) {
      return [
        const ParentMainScreen(),
        _buildPlaceholderPage('Anak-anak', AppColors.parentPrimary),
        _buildPlaceholderPage('Transaksi', AppColors.parentPrimary),
        _buildPlaceholderPage('Laporan', AppColors.parentPrimary),
        _buildPlaceholderPage('Profil', AppColors.parentPrimary),
      ];
    }

    // CHILD
    switch (widget.user.ageTier) {
      case AgeTier.tingkat1:
      // MUST be 4 pages to match 4 nav items
        return [
          Tingkat1HomeScreen(
            user: widget.user,
            onTabChange: (i) => setState(() => _currentIndex = i),
          ),
          Tingkat1SavingsScreen(user: widget.user),
          Tingkat1MissionsScreen(user: widget.user),
          Tingkat1ProfileScreen(user: widget.user),
        ];
      case AgeTier.tingkat2:
        return [
          Tingkat2HomeScreen(user: widget.user),
          Tingkat2SavingsScreen(user: widget.user),
          Tingkat2MissionsScreen(user: widget.user),
          Tingkat2TransactionsScreen(user: widget.user),
          Tingkat2ProfileScreen(user: widget.user), // with Logout, settings, etc.
        ];
      case AgeTier.tingkat3:
        return [
          _buildPlaceholderPage('Beranda Tingkat 3', AppColors.tingkat3Primary),
          _buildPlaceholderPage('Budget Tingkat 3', AppColors.tingkat3Primary),
          _buildPlaceholderPage('Investasi Tingkat 3', AppColors.tingkat3Primary),
          _buildPlaceholderPage('Transaksi Tingkat 3', AppColors.tingkat3Primary),
          _buildPlaceholderPage('Profil Tingkat 3', AppColors.tingkat3Primary),
        ];
      default:
        return [_buildPlaceholderPage('Unknown tier', AppColors.error)];
    }
  }

  List<BottomNavigationBarItem> _getBottomNavItems() {
    if (widget.user.type == UserType.parent) {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.child_care_outlined),
          activeIcon: Icon(Icons.child_care),
          label: 'Anak',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          activeIcon: Icon(Icons.receipt_long),
          label: 'Transaksi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          activeIcon: Icon(Icons.analytics),
          label: 'Laporan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ];
    }

    switch (widget.user.ageTier) {
      case AgeTier.tingkat1:
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings_outlined),
            activeIcon: Icon(Icons.savings),
            label: 'Celengan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Misi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ];
      case AgeTier.tingkat2:
      case AgeTier.tingkat3:
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings_outlined),
            activeIcon: Icon(Icons.savings),
            label: 'Celengan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Misi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ];
      default:
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.error_outline),
            activeIcon: Icon(Icons.error),
            label: 'Unknown',
          ),
        ];
    }
  }

  Color _getPrimaryColor(ThemeColor theme) {
    if (widget.user.type == UserType.parent) return AppColors.parentPrimary;
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
                    children: const [
                      Icon(Icons.construction, size: 64, color: AppColors.grey400),
                      SizedBox(height: 16),
                      Text(
                        'Coming soon...',
                        style: TextStyle(fontSize: 16, color: AppColors.grey500),
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
