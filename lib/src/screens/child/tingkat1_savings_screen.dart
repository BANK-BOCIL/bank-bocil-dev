// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import '../../models/user.dart';
// import '../../models/savings_goal.dart';
// import '../../models/transaction.dart';
// import '../../providers/app_provider.dart';
// import '../../core/constants.dart';
// import '../../core/helpers.dart';
// import '../../widgets/savings_goals_carousel.dart';
// import 'create_savings_goal_screen.dart';

// class Tingkat1SavingsScreen extends StatelessWidget {
//   final User user;

//   const Tingkat1SavingsScreen({
//     super.key,
//     required this.user,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppProvider>(
//       builder: (context, appProvider, child) {
//         return Scaffold(
//           backgroundColor:
//               AppColors.getCurrentSecondary(appProvider.currentTheme),
//           body: SafeArea(
//             child: Consumer<AppProvider>(
//               builder: (context, provider, child) {
//                 final goals = provider.getSavingsGoalsForUser(user.id);
//                 final activeGoals =
//                     goals.where((g) => g.status == GoalStatus.active).toList();
//                 final completedGoals = goals
//                     .where((g) => g.status == GoalStatus.completed)
//                     .toList();

//                 return SingleChildScrollView(
//                   padding: const EdgeInsets.all(AppConstants.spacing16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header
//                       _buildHeader(context, appProvider.currentTheme),

//                       Helpers.verticalSpace(AppConstants.spacing24),

//                       // Create New Goal Button
//                       _buildCreateGoalButton(context, appProvider.currentTheme),

//                       Helpers.verticalSpace(AppConstants.spacing24),

//                       // Active Goals
//                       if (activeGoals.isNotEmpty) ...[
//                         _buildSectionTitle('🎯 Target Aktif'),
//                         Helpers.verticalSpace(AppConstants.spacing12),
//                         SavingsGoalsCarousel(
//                           goals: activeGoals,
//                           ageTier: AgeTier.tingkat1,
//                           theme: appProvider.currentTheme,
//                           onGoalTap: (goal) => _showGoalDetail(
//                               context, goal, appProvider.currentTheme),
//                         ),
//                         Helpers.verticalSpace(AppConstants.spacing24),
//                       ],

//                       // Completed Goals
//                       if (completedGoals.isNotEmpty) ...[
//                         _buildSectionTitle('🏆 Target Selesai'),
//                         Helpers.verticalSpace(AppConstants.spacing12),
//                         ...completedGoals.map((goal) => Padding(
//                               padding: const EdgeInsets.only(
//                                   bottom: AppConstants.spacing12),
//                               child: _buildCompletedGoalCard(
//                                   goal, appProvider.currentTheme),
//                             )),
//                         Helpers.verticalSpace(AppConstants.spacing24),
//                       ],

//                       // Tips Section
//                       _buildTipsSection(appProvider.currentTheme),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildHeader(BuildContext context, ThemeColor theme) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(AppConstants.spacing20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             AppColors.getCurrentPrimary(theme),
//             AppColors.getCurrentAccent(theme),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 '🐷',
//                 style: const TextStyle(fontSize: 32),
//               ),
//               Helpers.horizontalSpace(AppConstants.spacing12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Celengan ${user.name}',
//                       style: const TextStyle(
//                         color: AppColors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Yuk kumpulkan uang untuk impianmu!',
//                       style: TextStyle(
//                         color: AppColors.white.withOpacity(0.9),
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCreateGoalButton(BuildContext context, ThemeColor theme) {
//     return GestureDetector(
//       onTap: () => _showCreateGoalDialog(context),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(AppConstants.spacing20),
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//           border: Border.all(
//             color: AppColors.getCurrentPrimary(theme).withOpacity(0.3),
//             width: 2,
//             style: BorderStyle.solid,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 color: AppColors.getCurrentPrimary(theme).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
//               ),
//               child: Icon(
//                 Icons.add,
//                 color: AppColors.getCurrentPrimary(theme),
//                 size: 24,
//               ),
//             ),
//             Helpers.horizontalSpace(AppConstants.spacing16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Buat Target Baru',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.grey800,
//                     ),
//                   ),
//                   Text(
//                     'Apa yang ingin kamu beli?',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: AppColors.grey600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               Icons.arrow_forward_ios,
//               color: AppColors.grey400,
//               size: 16,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         color: AppColors.grey800,
//       ),
//     );
//   }

//   Widget _buildCompletedGoalCard(SavingsGoal goal, ThemeColor theme) {
//     return Container(
//       padding: const EdgeInsets.all(AppConstants.spacing16),
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
//       child: Row(
//         children: [
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: AppColors.success.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
//             ),
//             child: Center(
//               child: Text(
//                 AppConstants.goalIcons[goal.iconName] ??
//                     AppConstants.goalIcons['default']!,
//                 style: const TextStyle(fontSize: 24),
//               ),
//             ),
//           ),
//           Helpers.horizontalSpace(AppConstants.spacing16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   goal.name,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.grey800,
//                   ),
//                 ),
//                 Text(
//                   'Selesai ${Helpers.formatDate(goal.completedAt!)}',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: AppColors.grey600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: AppConstants.spacing12,
//               vertical: AppConstants.spacing8,
//             ),
//             decoration: BoxDecoration(
//               color: AppColors.success.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
//             ),
//             child: Text(
//               'Selesai!',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.success,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTipsSection(ThemeColor theme) {
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
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '💡 Tips Menabung',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: AppColors.grey800,
//             ),
//           ),
//           Helpers.verticalSpace(AppConstants.spacing12),
//           _buildTip('🎯', 'Tentukan target yang jelas'),
//           _buildTip('💰', 'Sisihkan uang saku sedikit demi sedikit'),
//           _buildTip('📅', 'Nabung secara rutin setiap hari'),
//           _buildTip('🎉', 'Rayakan ketika target tercapai'),
//         ],
//       ),
//     );
//   }

//   Widget _buildTip(String emoji, String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: AppConstants.spacing8),
//       child: Row(
//         children: [
//           Text(emoji, style: const TextStyle(fontSize: 16)),
//           Helpers.horizontalSpace(AppConstants.spacing8),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: AppColors.grey600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showGoalDetail(
//       BuildContext context, SavingsGoal goal, ThemeColor theme) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.7,
//         padding: const EdgeInsets.all(AppConstants.spacing20),
//         decoration: const BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(AppConstants.radiusLarge),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Handle
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: AppColors.grey300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//             Helpers.verticalSpace(AppConstants.spacing20),

//             // Goal Icon and Name
//             Row(
//               children: [
//                 Container(
//                   width: 64,
//                   height: 64,
//                   decoration: BoxDecoration(
//                     color: AppColors.getCurrentPrimary(theme).withOpacity(0.1),
//                     borderRadius:
//                         BorderRadius.circular(AppConstants.radiusLarge),
//                   ),
//                   child: Center(
//                     child: Text(
//                       AppConstants.goalIcons[goal.iconName] ??
//                           AppConstants.goalIcons['default']!,
//                       style: const TextStyle(fontSize: 32),
//                     ),
//                   ),
//                 ),
//                 Helpers.horizontalSpace(AppConstants.spacing16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         goal.name,
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.grey800,
//                         ),
//                       ),
//                       Text(
//                         goal.description,
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: AppColors.grey600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             Helpers.verticalSpace(AppConstants.spacing24),

//             // Progress
//             Container(
//               padding: const EdgeInsets.all(AppConstants.spacing20),
//               decoration: BoxDecoration(
//                 color: AppColors.getCurrentSecondary(theme),
//                 borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Progress',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.grey800,
//                         ),
//                       ),
//                       Text(
//                         '${goal.progressPercentage.toInt()}%',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.getCurrentPrimary(theme),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Helpers.verticalSpace(AppConstants.spacing12),
//                   LinearProgressIndicator(
//                     value: goal.progressPercentage / 100,
//                     backgroundColor: AppColors.grey200,
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                         AppColors.getCurrentPrimary(theme)),
//                     minHeight: 8,
//                   ),
//                   Helpers.verticalSpace(AppConstants.spacing12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         Helpers.formatCurrency(goal.currentAmount),
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.getCurrentPrimary(theme),
//                         ),
//                       ),
//                       Text(
//                         'dari ${Helpers.formatCurrency(goal.targetAmount)}',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: AppColors.grey600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             Helpers.verticalSpace(AppConstants.spacing24),

//             // Add Money Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _showAddMoneyDialog(context, goal);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.getCurrentPrimary(theme),
//                   foregroundColor: AppColors.white,
//                   padding: const EdgeInsets.symmetric(
//                       vertical: AppConstants.spacing16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius:
//                         BorderRadius.circular(AppConstants.radiusMedium),
//                   ),
//                 ),
//                 child:
//                     const Text('Tambah Uang', style: TextStyle(fontSize: 16)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showCreateGoalDialog(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CreateSavingsGoalScreen(user: user),
//       ),
//     );
//   }

//   void _showAddMoneyDialog(BuildContext context, SavingsGoal goal) {
//     final TextEditingController amountController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Consumer<AppProvider>(
//           builder: (context, appProvider, child) {
//             final availableMoney = appProvider.getBalance(user.id);
//             final remainingAmount = goal.targetAmount - goal.currentAmount;
//             final maxAmount = availableMoney < remainingAmount
//                 ? availableMoney
//                 : remainingAmount;

//             return AlertDialog(
//               backgroundColor: AppColors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//               ),
//               title: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(AppConstants.spacing12),
//                     decoration: BoxDecoration(
//                       color:
//                           AppColors.getCurrentPrimary(appProvider.currentTheme)
//                               .withOpacity(0.1),
//                       borderRadius:
//                           BorderRadius.circular(AppConstants.radiusMedium),
//                     ),
//                     child: Text(
//                       AppConstants.goalIcons[goal.iconName] ?? '🎯',
//                       style: const TextStyle(fontSize: 32),
//                     ),
//                   ),
//                   Helpers.verticalSpace(AppConstants.spacing12),
//                   Text(
//                     'Tambah ke ${goal.name}',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.grey800,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Info Cards
//                   Container(
//                     padding: const EdgeInsets.all(AppConstants.spacing12),
//                     decoration: BoxDecoration(
//                       color: AppColors.getCurrentSecondary(
//                           appProvider.currentTheme),
//                       borderRadius:
//                           BorderRadius.circular(AppConstants.radiusMedium),
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Uang Kamu:',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: AppColors.grey600,
//                               ),
//                             ),
//                             Text(
//                               Helpers.formatCurrency(availableMoney),
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.getCurrentPrimary(
//                                     appProvider.currentTheme),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Helpers.verticalSpace(AppConstants.spacing8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Sisa Target:',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: AppColors.grey600,
//                               ),
//                             ),
//                             Text(
//                               Helpers.formatCurrency(remainingAmount),
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.grey800,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   Helpers.verticalSpace(AppConstants.spacing16),

//                   // Amount Input
//                   Text(
//                     'Jumlah Uang',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.grey800,
//                     ),
//                   ),
//                   Helpers.verticalSpace(AppConstants.spacing8),
//                   TextField(
//                     controller: amountController,
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                     ],
//                     decoration: InputDecoration(
//                       hintText: 'Masukkan jumlah uang',
//                       hintStyle: TextStyle(color: AppColors.grey500),
//                       prefixIcon: Icon(Icons.money, color: AppColors.grey600),
//                       prefixText: 'Rp ',
//                       border: OutlineInputBorder(
//                         borderRadius:
//                             BorderRadius.circular(AppConstants.radiusMedium),
//                         borderSide: BorderSide(color: AppColors.grey300),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius:
//                             BorderRadius.circular(AppConstants.radiusMedium),
//                         borderSide: BorderSide(
//                             color: AppColors.getCurrentPrimary(
//                                 appProvider.currentTheme),
//                             width: 2),
//                       ),
//                       filled: true,
//                       fillColor: AppColors.white,
//                     ),
//                   ),

//                   Helpers.verticalSpace(AppConstants.spacing12),

//                   // Quick Amount Buttons
//                   if (maxAmount > 0) ...[
//                     Text(
//                       'Pilih Cepat:',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: AppColors.grey600,
//                       ),
//                     ),
//                     Helpers.verticalSpace(AppConstants.spacing8),
//                     Wrap(
//                       spacing: 8,
//                       children: [
//                         if (maxAmount >= 5000)
//                           _buildQuickAmountButton(
//                               5000, amountController, appProvider.currentTheme),
//                         if (maxAmount >= 10000)
//                           _buildQuickAmountButton(10000, amountController,
//                               appProvider.currentTheme),
//                         if (maxAmount >= 25000)
//                           _buildQuickAmountButton(25000, amountController,
//                               appProvider.currentTheme),
//                         if (maxAmount > 0)
//                           _buildQuickAmountButton(maxAmount.toInt(),
//                               amountController, appProvider.currentTheme,
//                               isMax: true),
//                       ],
//                     ),
//                   ],
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: Text(
//                     'Batal',
//                     style: TextStyle(color: AppColors.grey600),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: maxAmount <= 0
//                       ? null
//                       : () {
//                           final amount = double.tryParse(amountController.text);
//                           if (amount != null &&
//                               amount > 0 &&
//                               amount <= maxAmount) {
//                             _addMoneyToGoal(context, goal, amount, appProvider);
//                             Navigator.of(context).pop();
//                           } else {
//                             Helpers.showSnackBar(
//                                 context,
//                                 amount == null || amount <= 0
//                                     ? 'Masukkan jumlah yang valid'
//                                     : 'Jumlah melebihi uang yang tersedia atau sisa target');
//                           }
//                         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         AppColors.getCurrentPrimary(appProvider.currentTheme),
//                     foregroundColor: AppColors.white,
//                   ),
//                   child: const Text('Tambah'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildQuickAmountButton(
//       int amount, TextEditingController controller, ThemeColor theme,
//       {bool isMax = false}) {
//     return GestureDetector(
//       onTap: () {
//         controller.text = amount.toString();
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(
//           horizontal: AppConstants.spacing12,
//           vertical: AppConstants.spacing8,
//         ),
//         decoration: BoxDecoration(
//           color: AppColors.getCurrentPrimary(theme).withOpacity(0.1),
//           borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
//           border: Border.all(
//             color: AppColors.getCurrentPrimary(theme).withOpacity(0.3),
//           ),
//         ),
//         child: Text(
//           isMax ? 'Semua' : Helpers.formatCurrency(amount.toDouble()),
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: AppColors.getCurrentPrimary(theme),
//           ),
//         ),
//       ),
//     );
//   }

//   void _addMoneyToGoal(BuildContext context, SavingsGoal goal, double amount,
//       AppProvider provider) {
//     try {
//       // Check if user has enough balance
//       final currentBalance = provider.getBalance(user.id);
//       if (currentBalance < amount) {
//         Helpers.showSnackBar(context, '❌ Uang kamu tidak cukup!');
//         return;
//       }

//       // Check if amount doesn't exceed remaining target
//       final remainingAmount = goal.targetAmount - goal.currentAmount;
//       if (amount > remainingAmount) {
//         Helpers.showSnackBar(context, '❌ Jumlah melebihi sisa target!');
//         return;
//       }

//       // Create expense transaction for the savings goal
//       final transaction = Transaction(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         userId: user.id,
//         type: TransactionType.expense,
//         amount: amount,
//         description: 'Menabung untuk ${goal.name}',
//         category: 'Tabungan',
//         status: TransactionStatus.completed,
//         createdAt: DateTime.now(),
//         savingsGoalId: goal.id,
//       );

//       // Add transaction
//       provider.addTransaction(transaction);

//       // Update goal amount
//       final updatedGoal = goal.copyWith(
//         currentAmount: goal.currentAmount + amount,
//       );

//       // Update provider
//       provider.updateSavingsGoal(updatedGoal);

//       // Show success message
//       final isCompleted = updatedGoal.currentAmount >= updatedGoal.targetAmount;
//       final message = isCompleted
//           ? '🎉 Selamat! Target "${goal.name}" sudah tercapai!'
//           : '💰 Berhasil menambah ${Helpers.formatCurrency(amount)} ke "${goal.name}"!';

//       Helpers.showSnackBar(context, message);
//     } catch (e) {
//       Helpers.showSnackBar(
//           context, '❌ Gagal menambah uang. Silakan coba lagi.');
//     }
//   }
// }
