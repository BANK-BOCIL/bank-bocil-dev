import 'package:flutter/material.dart';
import '../models/savings_goal.dart';
import '../models/user.dart';
import '../core/constants.dart';
import '../core/helpers.dart';

class SavingsGoalsCarousel extends StatelessWidget {
  final List<SavingsGoal> goals;
  final AgeTier ageTier;
  final ThemeColor? theme;
  final Function(SavingsGoal)? onGoalTap;

  const SavingsGoalsCarousel({
    super.key,
    required this.goals,
    required this.ageTier,
    this.theme,
    this.onGoalTap,
  });

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return _buildEmptyState();
    }

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing4),
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];
          return Padding(
            padding: const EdgeInsets.only(right: AppConstants.spacing12),
            child: _buildGoalCard(goal),
          );
        },
      ),
    );
  }

  Widget _buildGoalCard(SavingsGoal goal) {
    return GestureDetector(
      onTap: () => onGoalTap?.call(goal),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(AppConstants.spacing12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRect(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Goal Icon/Image
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getPrimaryColor().withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMedium),
                ),
                child: Center(
                  child: Text(
                    AppConstants.goalIcons[goal.iconName] ??
                        AppConstants.goalIcons['default']!,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),

              Helpers.verticalSpace(AppConstants.spacing8),

              // Goal Name
              Text(
                goal.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              Helpers.verticalSpace(AppConstants.spacing4),

              // Progress
              Text(
                Helpers.formatCurrency(goal.currentAmount),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getPrimaryColor(),
                ),
              ),
              Text(
                'dari ${Helpers.formatCurrency(goal.targetAmount)}',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.grey500,
                ),
              ),

              Helpers.verticalSpace(AppConstants.spacing4),

              // Progress Bar
              LinearProgressIndicator(
                value: goal.progressPercentage / 100,
                backgroundColor: AppColors.grey200,
                valueColor: AlwaysStoppedAnimation<Color>(_getPrimaryColor()),
                minHeight: 6,
              ),

              Helpers.verticalSpace(AppConstants.spacing4),

              // Progress Percentage
              Text(
                '${goal.progressPercentage.toInt()}%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacing24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(
          color: AppColors.grey200,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '🎯',
            style: const TextStyle(fontSize: 32),
          ),
          Helpers.verticalSpace(AppConstants.spacing8),
          Text(
            'Belum ada target tabungan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.grey600,
            ),
          ),
          Helpers.verticalSpace(AppConstants.spacing4),
          Text(
            'Yuk buat target pertamamu!',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
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
