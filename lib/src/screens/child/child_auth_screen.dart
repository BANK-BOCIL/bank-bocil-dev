import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/helpers.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_provider.dart';
import '../../models/auth_user.dart';
import '../../models/user.dart';
import '../main_navigation_screen.dart';

class ChildAuthScreen extends StatefulWidget {
  const ChildAuthScreen({super.key});

  @override
  State<ChildAuthScreen> createState() => _ChildAuthScreenState();
}

class _ChildAuthScreenState extends State<ChildAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.loginChild(
      childCode: _codeController.text.trim().toUpperCase(),
      childName: _nameController.text.trim(),
    );

    if (success && mounted) {
      // Create app User from auth user
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final authUser = authProvider.currentUser!;
      final user = User(
        id: authUser.id,
        name: authUser.name,
        type: UserType.child,
        ageTier: AgeTier.tingkat1,
        parentId: authUser.parentId,
        createdAt: authUser.createdAt,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainNavigationScreen(user: user),
        ),
      );
    } else if (mounted && authProvider.error != null) {
      Helpers.showSnackBar(context, authProvider.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Anak'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.tingkat1Primary,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '🧒',
                    style: TextStyle(fontSize: 50),
                  ),
                ),
              ),

              Helpers.verticalSpace(AppConstants.spacing32),

              // Title
              const Text(
                'Halo, Anak Pintar! 👋',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey800,
                ),
              ),
              Helpers.verticalSpace(AppConstants.spacing8),
              Text(
                'Masukkan kode dari orang tua untuk memulai petualangan menabung!',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),

              Helpers.verticalSpace(AppConstants.spacing32),

              // Code Field
              TextFormField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: 'Kode Anak',
                  hintText: 'Masukkan kode dari orang tua',
                  prefixIcon:
                      const Icon(Icons.key, color: AppColors.tingkat1Primary),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                    borderSide: const BorderSide(
                        color: AppColors.tingkat1Primary, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.grey50,
                ),
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Kode tidak boleh kosong';
                  }
                  if (value!.trim().length != 6) {
                    return 'Kode harus 6 karakter';
                  }
                  return null;
                },
              ),

              Helpers.verticalSpace(AppConstants.spacing16),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Kamu',
                  hintText: 'Masukkan nama lengkap kamu',
                  prefixIcon: const Icon(Icons.person,
                      color: AppColors.tingkat1Primary),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                    borderSide: const BorderSide(
                        color: AppColors.tingkat1Primary, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.grey50,
                ),
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Nama tidak boleh kosong';
                  }
                  if (value!.trim().length < 2) {
                    return 'Nama minimal 2 karakter';
                  }
                  return null;
                },
              ),

              Helpers.verticalSpace(AppConstants.spacing32),

              // Login Button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tingkat1Primary,
                        foregroundColor: AppColors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMedium),
                        ),
                      ),
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white),
                              ),
                            )
                          : const Text(
                              'Masuk Sekarang! 🚀',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
