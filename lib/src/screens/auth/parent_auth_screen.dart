// lib/src/screens/auth/parent_auth_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/helpers.dart';
import '../../providers/auth_provider.dart';

class ParentAuthScreen extends StatefulWidget {
  const ParentAuthScreen({super.key});

  @override
  State<ParentAuthScreen> createState() => _ParentAuthScreenState();
}

class _ParentAuthScreenState extends State<ParentAuthScreen> {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // PERBAIKAN: Tambahkan controller untuk umur
  final _ageController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose(); // PERBAIKAN: dispose controller umur
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _formKey.currentState?.reset();
    });
  }

  Future<void> _handleSubmit() async {
    // Sembunyikan keyboard
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_isLogin) {
      await authProvider.loginParent(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } else {
      // PERBAIKAN: Ambil umur dari controller
      await authProvider.registerParent(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        age: int.tryParse(_ageController.text.trim()) ?? 0,
      );
    }

    if (mounted && authProvider.error != null) {
      Helpers.showSnackBar(context, authProvider.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Masuk Akun Orang Tua' : 'Buat Akun Orang Tua'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // PERBAIKAN: Tambahkan field umur hanya saat registrasi
                if (!_isLogin) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration:
                        const InputDecoration(labelText: 'Nama Lengkap'),
                    validator: (value) => (value?.isEmpty ?? true)
                        ? 'Nama tidak boleh kosong'
                        : null,
                  ),
                  Helpers.verticalSpace(AppConstants.spacing16),
                ],
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true)
                      return 'Email tidak boleh kosong';
                    if (!Helpers.isValidEmail(value!))
                      return 'Format email tidak valid';
                    return null;
                  },
                ),
                Helpers.verticalSpace(AppConstants.spacing16),
                // PERBAIKAN: Tambahkan input umur hanya untuk registrasi
                if (!_isLogin) ...[
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: 'Umur'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true)
                        return 'Umur tidak boleh kosong';
                      if (int.tryParse(value!) == null)
                        return 'Umur harus angka';
                      return null;
                    },
                  ),
                  Helpers.verticalSpace(AppConstants.spacing16),
                ],
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value?.isEmpty ?? true)
                      return 'Password tidak boleh kosong';
                    if (value!.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),
                if (!_isLogin) ...[
                  Helpers.verticalSpace(AppConstants.spacing16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () => setState(() =>
                            _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                    ),
                    obscureText: _obscureConfirmPassword,
                    validator: (value) {
                      if (value != _passwordController.text)
                        return 'Password tidak cocok';
                      return null;
                    },
                  ),
                ],
                Helpers.verticalSpace(AppConstants.spacing32),
                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    return ElevatedButton(
                      onPressed: auth.isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.spacing16),
                        backgroundColor: AppColors.primary,
                      ),
                      child: auth.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : Text(_isLogin ? 'Masuk' : 'Daftar'),
                    );
                  },
                ),
                TextButton(
                  onPressed: _toggleMode,
                  child: Text(_isLogin
                      ? 'Belum punya akun? Daftar'
                      : 'Sudah punya akun? Masuk'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
