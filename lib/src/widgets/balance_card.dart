import 'package:flutter/material.dart';
import '../models/user.dart';
import '../core/constants.dart';
import '../core/helpers.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final AgeTier ageTier;
  final ThemeColor? theme;
  final VoidCallback? onTap;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.ageTier,
    this.theme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.spacing24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getGradientColors(),
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: _getPrimaryColor().withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getBalanceTitle(),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Helpers.verticalSpace(AppConstants.spacing8),
                    Text(
                      Helpers.formatCurrency(balance),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacing12),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  child: Icon(
                    _getBalanceIcon(),
                    color: AppColors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
            Helpers.verticalSpace(AppConstants.spacing16),
            if (ageTier == AgeTier.tingkat1) ...[
              Text(
                '🎉 Kamu hebat! Terus nabung ya!',
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ] else if (ageTier == AgeTier.tingkat2) ...[
              Text(
                '💪 Saldo kamu terus bertambah!',
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    color: AppColors.white.withOpacity(0.9),
                    size: 16,
                  ),
                  Helpers.horizontalSpace(AppConstants.spacing8),
                  Text(
                    'Kelola uangmu dengan bijak',
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Color> _getGradientColors() {
    // Use dynamic theme if available, otherwise fallback to age tier colors
    if (theme != null) {
      final primary = AppColors.getCurrentPrimary(theme!);
      final accent = AppColors.getCurrentAccent(theme!);
      return [primary, accent];
    }

    switch (ageTier) {
      case AgeTier.tingkat1:
        return [AppColors.tingkat1Primary, AppColors.tingkat1Accent];
      case AgeTier.tingkat2:
        return [AppColors.tingkat2Primary, AppColors.tingkat2Accent];
      case AgeTier.tingkat3:
        return [AppColors.tingkat3Primary, AppColors.tingkat3Accent];
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

  String _getBalanceTitle() {
    switch (ageTier) {
      case AgeTier.tingkat1:
        return '💰 Uang Kamu';
      case AgeTier.tingkat2:
        return '💳 E-Wallet';
      case AgeTier.tingkat3:
        return '💼 Saldo Total';
    }
  }

  IconData _getBalanceIcon() {
    switch (ageTier) {
      case AgeTier.tingkat1:
        return Icons.savings;
      case AgeTier.tingkat2:
        return Icons.account_balance_wallet;
      case AgeTier.tingkat3:
        return Icons.account_balance;
    }
  }
}
