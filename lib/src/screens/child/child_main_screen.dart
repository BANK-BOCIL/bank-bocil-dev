import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/app_provider.dart';
import '../../core/constants.dart';

class ChildMainScreen extends StatelessWidget {
  final User user;

  const ChildMainScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Halo, ${user.name}!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey800,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Ini adalah Dashboard utama anak.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey600,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Tingkat Usia: ${user.ageTier?.name ?? 'Tidak Ada'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
