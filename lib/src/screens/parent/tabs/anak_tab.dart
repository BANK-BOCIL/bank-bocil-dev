// lib/src/screens/parent/tabs/anak_tab.dart
import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../../../models/account.dart';
import '../../../core/constants.dart';
import '../../../core/helpers.dart';

class AnakTab extends StatelessWidget {
  const AnakTab({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Temporary Static Data ---
    final List<Map<String, dynamic>> mockChildrenData = [
      {
        'user': User(
          id: 'child1',
          name: 'Andi',
          type: UserType.child,
          age: 8,
          ageTier: AgeTier.tingkat1,
          parentId: 'parent1',
          createdAt: DateTime.now(),
        ),
        'account': Account(
          userId: 'child1',
          balance: 25000,
          lastUpdated: DateTime.now(),
        ),
        'stats': {
          'tasksCompleted': 12,
          'tasksPending': 2,
          'goalsActive': 2,
          'totalEarned': 50000.0,
          'status': 'Pemula',
          'lastActive': '2024-01-15 14:30',
        },
      },
      {
        'user': User(
          id: 'child2',
          name: 'Sari',
          type: UserType.child,
          age: 11,
          ageTier: AgeTier.tingkat2,
          parentId: 'parent1',
          createdAt: DateTime.now(),
        ),
        'account': Account(
          userId: 'child2',
          balance: 45000,
          lastUpdated: DateTime.now(),
        ),
        'stats': {
          'tasksCompleted': 18,
          'tasksPending': 1,
          'goalsActive': 3,
          'totalEarned': 80000.0,
          'status': 'Menengah',
          'lastActive': '2024-01-15 16:45',
        },
      },
    ];
    // --- End of Temporary Data ---

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      itemCount: mockChildrenData.length,
      itemBuilder: (context, index) {
        final data = mockChildrenData[index];
        return ChildInfoCard(
          child: data['user'],
          account: data['account'],
          tasksCompleted: data['stats']['tasksCompleted'],
          tasksPending: data['stats']['tasksPending'],
          goalsActive: data['stats']['goalsActive'],
          totalEarned: data['stats']['totalEarned'],
          status: data['stats']['status'],
          lastActive: data['stats']['lastActive'],
        );
      },
    );
  }
}

class ChildInfoCard extends StatelessWidget {
  final User child;
  final Account account;
  final int tasksCompleted;
  final int tasksPending;
  final int goalsActive;
  final double totalEarned;
  final String status;
  final String lastActive;

  const ChildInfoCard({
    super.key,
    required this.child,
    required this.account,
    required this.tasksCompleted,
    required this.tasksPending,
    required this.goalsActive,
    required this.totalEarned,
    required this.status,
    required this.lastActive,
  });

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
            const Divider(height: AppConstants.spacing24),
            _buildChildStats(),
            const Divider(height: AppConstants.spacing24),
            _buildCardFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildChildHeader() {
    final String avatarEmoji = child.age < 10 ? '👦' : '👧';
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
              Text(child.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Helpers.verticalSpace(AppConstants.spacing4),
              Text(
                '${child.age} tahun • Level ${child.ageTier?.name.replaceAll('tingkat', '')}',
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
            status,
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
            Expanded(
                child: _StatItem(
                    label: 'Saldo',
                    value: Helpers.formatCurrency(account.balance),
                    color: AppColors.success)),
            Expanded(
                child: _StatItem(
                    label: 'Total Earned',
                    value: Helpers.formatCurrency(totalEarned),
                    color: AppColors.primary)),
          ],
        ),
        Helpers.verticalSpace(AppConstants.spacing16),
        Row(
          children: [
            Expanded(
                child: _StatItem(
                    label: 'Tugas Selesai',
                    value: tasksCompleted.toString())),
            Expanded(
                child: _StatItem(
                    label: 'Tugas Pending', value: tasksPending.toString())),
            Expanded(
                child: _StatItem(
                    label: 'Target Tabungan', value: goalsActive.toString())),
          ],
        ),
      ],
    );
  }

  Widget _buildCardFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Terakhir aktif: $lastActive',
          style: const TextStyle(fontSize: 12, color: AppColors.grey500),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.visibility, size: 16),
          label: const Text('Lihat Dashboard'),
          style: ElevatedButton.styleFrom(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            textStyle: const TextStyle(fontSize: 12),
          ),
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
        Text(label,
            style: const TextStyle(fontSize: 12, color: AppColors.grey500)),
        Helpers.verticalSpace(AppConstants.spacing4),
        Text(value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color ?? AppColors.grey800)),
      ],
    );
  }
}
