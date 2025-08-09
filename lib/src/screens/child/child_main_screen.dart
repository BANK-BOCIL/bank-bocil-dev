// lib/src/screens/auth/child_auth_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/helpers.dart';
import '../../providers/auth_provider.dart';
// PERBAIKAN: Impor layar tujuan
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
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // --- PERBAIKAN UTAMA ADA DI SINI ---
  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = await authProvider.loginChild(
      childCode: _codeController.text.trim(),
      childName: _nameController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? 0,
    );

    if (mounted) {
      if (user != null) {
        // Jika login berhasil, navigasi ke halaman utama anak
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => MainNavigationScreen(user: user)),
        );
      } else if (authProvider.error != null) {
        // Jika gagal, tampilkan error
        Helpers.showSnackBar(context, authProvider.error!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... sisa UI Anda tidak perlu diubah ...
    return Scaffold(
      appBar: AppBar(title: const Text('Login Anak')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacing24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Halo, Anak Pintar! 👋',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Helpers.verticalSpace(AppConstants.spacing8),
              const Text(
                'Masukkan kode dari orang tua untuk memulai petualangan menabung!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.grey600),
              ),
              Helpers.verticalSpace(AppConstants.spacing32),
              TextFormField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(labelText: 'Kode Anak'),
                validator: (value) {
                  if (value?.trim().isEmpty ?? true)
                    return 'Kode tidak boleh kosong';
                  if (value!.trim().length != 6) return 'Kode harus 6 karakter';
                  return null;
                },
              ),
              Helpers.verticalSpace(AppConstants.spacing16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Kamu'),
                validator: (value) => (value?.trim().isEmpty ?? true)
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              Helpers.verticalSpace(AppConstants.spacing16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Umur Kamu'),
                validator: (value) {
                  if (value?.trim().isEmpty ?? true)
                    return 'Umur tidak boleh kosong';
                  if (int.tryParse(value!) == null) return 'Umur harus angka';
                  return null;
                },
              ),
              Helpers.verticalSpace(AppConstants.spacing32),
              Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  return ElevatedButton(
                    onPressed: auth.isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacing16),
                      backgroundColor: AppColors.tingkat1Primary,
                    ),
                    child: auth.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Masuk Sekarang! 🚀'),
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
