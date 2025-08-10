// lib/src/screens/parent/add_funds_screen.dart (NEW FILE)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../core/constants.dart';
import '../../core/helpers.dart';

class AddFundsScreen extends StatefulWidget {
  const AddFundsScreen({super.key});

  @override
  State<AddFundsScreen> createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends State<AddFundsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final amount = double.tryParse(_amountController.text);
    if (amount == null) return;

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.addFundsToParentAccount(amount);

    if (mounted) {
      if (appProvider.error == null) {
        Helpers.showSnackBar(context, 'Dana berhasil ditambahkan!');
        Navigator.of(context).pop();
      } else {
        Helpers.showSnackBar(context, appProvider.error!, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Dana Virtual')),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Dana',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Masukkan jumlah yang valid';
                  }
                  return null;
                },
              ),
              Helpers.verticalSpace(AppConstants.spacing32),
              Consumer<AppProvider>(
                builder: (context, provider, child) {
                  return ElevatedButton(
                    onPressed: provider.isLoading ? null : _handleSubmit,
                    child: provider.isLoading
                        ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white))
                        : const Text('Konfirmasi'),
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