import 'package:flutter/material.dart';
import '../models/mission.dart';
import '../models/user.dart';
import '../core/constants.dart';
import '../core/helpers.dart';

class MissionCard extends StatelessWidget {
  final Mission mission;
  final AgeTier ageTier;
  final ThemeColor? theme;
  final VoidCallback? onComplete;
  final VoidCallback? onTap;

  const MissionCard({
    super.key,
    required this.mission,
    required this.ageTier,
    this.theme,
    this.onComplete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
        child: Row(
          children: [
            // Mission Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _getPrimaryColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Center(
                child: Text(
                  AppConstants.missionIcons[mission.iconName] ??
                      AppConstants.missionIcons['default']!,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),

            Helpers.horizontalSpace(AppConstants.spacing16),

            // Mission Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mission Title
                  Text(
                    mission.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Helpers.verticalSpace(AppConstants.spacing4),

                  // Mission Description
                  Text(
                    mission.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Helpers.verticalSpace(AppConstants.spacing8),

                  // Reward and Deadline
                  Row(
                    children: [
                      // Reward
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacing8,
                          vertical: AppConstants.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusSmall),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.monetization_on,
                              size: 14,
                              color: AppColors.success,
                            ),
                            Helpers.horizontalSpace(AppConstants.spacing4),
                            Text(
                              Helpers.formatCurrency(mission.reward),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (mission.deadline != null) ...[
                        Helpers.horizontalSpace(AppConstants.spacing8),
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: mission.isOverdue
                              ? AppColors.error
                              : AppColors.grey500,
                        ),
                        Helpers.horizontalSpace(AppConstants.spacing4),
                        Text(
                          _getDeadlineText(),
                          style: TextStyle(
                            fontSize: 12,
                            color: mission.isOverdue
                                ? AppColors.error
                                : AppColors.grey500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Complete Button
            if (mission.isActive && onComplete != null) ...[
              Helpers.horizontalSpace(AppConstants.spacing12),
              GestureDetector(
                onTap: onComplete,
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.spacing8),
                  decoration: BoxDecoration(
                    color: _getPrimaryColor(),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: Icon(
                    Icons.check,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
              ),
            ] else if (mission.isCompleted) ...[
              Helpers.horizontalSpace(AppConstants.spacing12),
              Container(
                padding: const EdgeInsets.all(AppConstants.spacing8),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Icon(
                  Icons.done,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getDeadlineText() {
    if (mission.deadline == null) return '';

    final now = DateTime.now();
    final deadline = mission.deadline!;
    final difference = deadline.difference(now);

    if (difference.isNegative) {
      return 'Terlambat';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam';
    } else {
      return '${difference.inMinutes} menit';
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
