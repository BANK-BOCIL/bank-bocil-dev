// lib/src/screens/parent/transfer_funds_screen.dart (NEW FILE)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../core/constants.dart';
import '../../core/helpers.dart';
import '../../models/user.dart';

class TransferFundsScreen extends StatefulWidget {
  const TransferFundsScreen({super.key});

  @override
  State<TransferFundsScreen> createState() => _TransferFundsScreenState();
}

class _TransferFundsScreenState extends State<TransferFundsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  User? _selectedChild;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate() || _selectedChild == null) return;
    FocusScope.of(context).unfocus();

    final amount = double.tryParse(_amountController.text);
    if (amount == null) return;

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.transferFundsToChild(_selectedChild!.id, amount);

    if (mounted) {
      if (appProvider.error == null) {
        Helpers.showSnackBar(context, 'Dana berhasil ditransfer!');
        Navigator.of(context).pop();
      } else {
        Helpers.showSnackBar(context, appProvider.error!, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final children = appProvider.children;
    final parentBalance = appProvider.parentAccount?.balance ?? 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Kirim Uang Saku')),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Saldo Anda: ${Helpers.formatCurrency(parentBalance)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              Helpers.verticalSpace(AppConstants.spacing24),
              DropdownButtonFormField<User>(
                value: _selectedChild,
                hint: const Text('Pilih Anak'),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: children.map((User child) {
                  return DropdownMenuItem<User>(
                    value: child,
                    child: Text(child.name),
                  );
                }).toList(),
                onChanged: (User? newValue) {
                  setState(() {
                    _selectedChild = newValue;
                  });
                },
                validator: (value) =>
                value == null ? 'Pilih anak terlebih dahulu' : null,
              ),
              Helpers.verticalSpace(AppConstants.spacing16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Transfer',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah tidak boleh kosong';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Masukkan jumlah yang valid';
                  }
                  if (amount > parentBalance) return 'Saldo tidak mencukupi';
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
                        : const Text('Kirim Sekarang'),
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