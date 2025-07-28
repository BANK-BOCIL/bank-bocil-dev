import 'package:flutter/material.dart';
import '../models/user.dart';
import '../core/constants.dart';
import '../core/helpers.dart';

class QuickActions extends StatelessWidget {
  final AgeTier ageTier;
  final ThemeColor? theme;
  final Function(String) onActionTap;

  const QuickActions({
    super.key,
    required this.ageTier,
    this.theme,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final actions = _getActionsForTier();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '⚡ Aksi Cepat',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.grey800,
          ),
        ),
        Helpers.verticalSpace(AppConstants.spacing12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: AppConstants.spacing12,
            mainAxisSpacing: AppConstants.spacing12,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return _buildActionCard(action);
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(QuickAction action) {
    return GestureDetector(
      onTap: () => onActionTap(action.key),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getPrimaryColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Center(
                child: Text(
                  action.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            Helpers.verticalSpace(AppConstants.spacing8),
            Text(
              action.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.grey800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  List<QuickAction> _getActionsForTier() {
    switch (ageTier) {
      case AgeTier.tingkat1:
        return [
          QuickAction(
            key: 'add_goal',
            title: 'Buat Target Baru',
            emoji: '🎯',
          ),
          QuickAction(
            key: 'view_missions',
            title: 'Lihat Misi',
            emoji: '⭐',
          ),
          QuickAction(
            key: 'piggy_bank',
            title: 'Celengan Saya',
            emoji: '🐷',
          ),
          QuickAction(
            key: 'ask_parent',
            title: 'Minta Orangtua',
            emoji: '👨‍👩‍👧‍👦',
          ),
        ];
      case AgeTier.tingkat2:
        return [
          QuickAction(
            key: 'add_goal',
            title: 'Target Baru',
            emoji: '🎯',
          ),
          QuickAction(
            key: 'view_transactions',
            title: 'Riwayat Transaksi',
            emoji: '📋',
          ),
          QuickAction(
            key: 'dictionary',
            title: 'Kamus Keuangan',
            emoji: '📚',
          ),
          QuickAction(
            key: 'request_purchase',
            title: 'Minta Beli',
            emoji: '🛒',
          ),
        ];
      case AgeTier.tingkat3:
        return [
          QuickAction(
            key: 'create_budget',
            title: 'Buat Budget',
            emoji: '💰',
          ),
          QuickAction(
            key: 'investment_learn',
            title: 'Belajar Investasi',
            emoji: '📈',
          ),
          QuickAction(
            key: 'financial_goals',
            title: 'Target Keuangan',
            emoji: '🎯',
          ),
          QuickAction(
            key: 'expense_tracker',
            title: 'Catat Pengeluaran',
            emoji: '📊',
          ),
        ];
    }
  }

  Color _getPrimaryColor() {
    // Use dynamic theme if available, otherwise fallback to age tier colors
    if (theme != null) {
      return AppColors.getCurrentPrimary(theme!);
    }

    switch (ageTier) {
      case AgeTier.tingkat1:
        return AppColors.tingkat1Primary;
      case AgeTier.tingkat2:
        return AppColors.tingkat2Primary;
      case AgeTier.tingkat3:
        return AppColors.tingkat3Primary;
    }
  }
}

class QuickAction {
  final String key;
  final String title;
  final String emoji;

  QuickAction({
    required this.key,
    required this.title,
    required this.emoji,
  });
}
