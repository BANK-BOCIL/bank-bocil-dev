// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import '../../models/user.dart';
// import '../../models/savings_goal.dart';
// import '../../providers/app_provider.dart';
// import '../../core/constants.dart';
// import '../../core/helpers.dart';

// class CreateSavingsGoalScreen extends StatefulWidget {
//   final User user;

//   const CreateSavingsGoalScreen({
//     super.key,
//     required this.user,
//   });

//   @override
//   State<CreateSavingsGoalScreen> createState() =>
//       _CreateSavingsGoalScreenState();
// }

// class _CreateSavingsGoalScreenState extends State<CreateSavingsGoalScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _targetAmountController = TextEditingController();

//   String _selectedIcon = 'toys';
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _targetAmountController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppProvider>(
//       builder: (context, appProvider, child) {
//         return Scaffold(
//           backgroundColor:
//               AppColors.getCurrentSecondary(appProvider.currentTheme),
//           appBar: _buildAppBar(appProvider.currentTheme),
//           body: SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(AppConstants.spacing16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header
//                     _buildHeader(appProvider.currentTheme),

//                     Helpers.verticalSpace(AppConstants.spacing24),

//                     // Form Fields
//                     _buildNameField(),

//                     Helpers.verticalSpace(AppConstants.spacing20),

//                     _buildTargetAmountField(),

//                     Helpers.verticalSpace(AppConstants.spacing20),

//                     _buildIconSelector(appProvider.currentTheme),

//                     Helpers.verticalSpace(AppConstants.spacing32),

//                     // Create Button
//                     _buildCreateButton(appProvider),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   PreferredSizeWidget _buildAppBar(ThemeColor theme) {
//     return AppBar(
//       backgroundColor: AppColors.getCurrentPrimary(theme),
//       foregroundColor: AppColors.white,
//       title: const Text(
//         'Buat Target Baru',
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: AppColors.white,
//         ),
//       ),
//       centerTitle: true,
//       elevation: 0,
//     );
//   }

//   Widget _buildHeader(ThemeColor theme) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(AppConstants.spacing20),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(AppConstants.spacing16),
//             decoration: BoxDecoration(
//               color: AppColors.getCurrentPrimary(theme).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
//             ),
//             child: Text(
//               '🎯',
//               style: const TextStyle(fontSize: 48),
//             ),
//           ),
//           Helpers.verticalSpace(AppConstants.spacing12),
//           Text(
//             'Ayo Buat Target Tabungan!',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: AppColors.grey800,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           Helpers.verticalSpace(AppConstants.spacing8),
//           Text(
//             'Tentukan apa yang ingin kamu beli dan mulai menabung untuk mencapainya!',
//             style: TextStyle(
//               fontSize: 14,
//               color: AppColors.grey600,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNameField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Nama Target',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: AppColors.grey800,
//           ),
//         ),
//         Helpers.verticalSpace(AppConstants.spacing8),
//         TextFormField(
//           controller: _nameController,
//           decoration: InputDecoration(
//             hintText: 'Contoh: Sepeda Baru, Mainan Robot, dll',
//             hintStyle: TextStyle(color: AppColors.grey500),
//             prefixIcon: Icon(Icons.text_fields, color: AppColors.grey600),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
//               borderSide: BorderSide(color: AppColors.grey300),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
//               borderSide: BorderSide(color: AppColors.primary, width: 2),
//             ),
//             filled: true,
//             fillColor: AppColors.white,
//           ),
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Nama target tidak boleh kosong';
//             }
//             if (value.trim().length < 3) {
//               return 'Nama target minimal 3 karakter';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildTargetAmountField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Harga Target',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: AppColors.grey800,
//           ),
//         ),
//         Helpers.verticalSpace(AppConstants.spacing8),
//         TextFormField(
//           controller: _targetAmountController,
//           keyboardType: TextInputType.number,
//           inputFormatters: [
//             FilteringTextInputFormatter.digitsOnly,
//           ],
//           decoration: InputDecoration(
//             hintText: 'Masukkan harga dalam Rupiah',
//             hintStyle: TextStyle(color: AppColors.grey500),
//             prefixIcon: Icon(Icons.money, color: AppColors.grey600),
//             prefixText: 'Rp ',
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
//               borderSide: BorderSide(color: AppColors.grey300),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
//               borderSide: BorderSide(color: AppColors.primary, width: 2),
//             ),
//             filled: true,
//             fillColor: AppColors.white,
//           ),
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Harga target tidak boleh kosong';
//             }
//             final amount = double.tryParse(value);
//             if (amount == null || amount <= 0) {
//               return 'Masukkan harga yang valid';
//             }
//             if (amount < 1000) {
//               return 'Harga minimal Rp 1.000';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildIconSelector(ThemeColor theme) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Pilih Icon Target',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: AppColors.grey800,
//           ),
//         ),
//         Helpers.verticalSpace(AppConstants.spacing8),
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(AppConstants.spacing16),
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
//             border: Border.all(color: AppColors.grey300),
//           ),
//           child: Column(
//             children: [
//               // Selected Icon Display
//               Container(
//                 padding: const EdgeInsets.all(AppConstants.spacing16),
//                 decoration: BoxDecoration(
//                   color: AppColors.getCurrentPrimary(theme).withOpacity(0.1),
//                   borderRadius:
//                       BorderRadius.circular(AppConstants.radiusMedium),
//                 ),
//                 child: Text(
//                   AppConstants.goalIcons[_selectedIcon] ?? '🎯',
//                   style: const TextStyle(fontSize: 48),
//                 ),
//               ),

//               Helpers.verticalSpace(AppConstants.spacing16),

//               // Icon Grid
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 6,
//                   crossAxisSpacing: 8,
//                   mainAxisSpacing: 8,
//                   childAspectRatio: 1,
//                 ),
//                 itemCount: AppConstants.goalIcons.length,
//                 itemBuilder: (context, index) {
//                   final entry = AppConstants.goalIcons.entries.elementAt(index);
//                   final iconKey = entry.key;
//                   final iconEmoji = entry.value;
//                   final isSelected = iconKey == _selectedIcon;

//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _selectedIcon = iconKey;
//                       });
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: isSelected
//                             ? AppColors.getCurrentPrimary(theme)
//                                 .withOpacity(0.2)
//                             : AppColors.grey100,
//                         borderRadius:
//                             BorderRadius.circular(AppConstants.radiusSmall),
//                         border: Border.all(
//                           color: isSelected
//                               ? AppColors.getCurrentPrimary(theme)
//                               : AppColors.grey300,
//                           width: isSelected ? 2 : 1,
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           iconEmoji,
//                           style: const TextStyle(fontSize: 24),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCreateButton(AppProvider provider) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: _isLoading ? null : () => _createSavingsGoal(provider),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.getCurrentPrimary(provider.currentTheme),
//           foregroundColor: AppColors.white,
//           padding: const EdgeInsets.symmetric(vertical: AppConstants.spacing16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
//           ),
//           elevation: 2,
//         ),
//         child: _isLoading
//             ? const SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                   color: AppColors.white,
//                   strokeWidth: 2,
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.add_circle, size: 20),
//                   Helpers.horizontalSpace(AppConstants.spacing8),
//                   const Text(
//                     'Buat Target Tabungan',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Future<void> _createSavingsGoal(AppProvider provider) async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final name = _nameController.text.trim();
//       final targetAmount = double.parse(_targetAmountController.text);

//       final newGoal = SavingsGoal(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         userId: widget.user.id,
//         name: name,
//         description: 'Target tabungan untuk $name',
//         targetAmount: targetAmount,
//         currentAmount: 0,
//         iconName: _selectedIcon,
//         createdAt: DateTime.now(),
//         status: GoalStatus.active,
//       );

//       provider.addSavingsGoal(newGoal);

//       // Show success message
//       if (mounted) {
//         Helpers.showSnackBar(
//           context,
//           '🎉 Target "$name" berhasil dibuat! Ayo mulai menabung!',
//         );

//         // Navigate back
//         Navigator.of(context).pop();
//       }
//     } catch (e) {
//       if (mounted) {
//         Helpers.showSnackBar(
//           context,
//           '❌ Gagal membuat target. Silakan coba lagi.',
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
// }
