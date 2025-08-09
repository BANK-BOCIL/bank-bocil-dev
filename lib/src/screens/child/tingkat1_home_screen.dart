// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import '../../models/user.dart';
// import '../../models/savings_goal.dart';
// import '../../models/transaction.dart';
// import '../../providers/app_provider.dart';
// import '../../core/constants.dart';
// import '../../core/helpers.dart';
// import '../../widgets/balance_card.dart';
// import '../../widgets/savings_goals_carousel.dart';
// import '../../widgets/mission_card.dart';
// import '../../widgets/quick_actions.dart';
// import 'create_savings_goal_screen.dart';
// import 'tingkat1_missions_screen.dart';
// import 'tingkat1_savings_screen.dart';

// class Tingkat1HomeScreen extends StatefulWidget {
//   final User user;
//   final Function(int)? onTabChange;

//   const Tingkat1HomeScreen({
//     super.key,
//     required this.user,
//     this.onTabChange,
//   });

//   @override
//   State<Tingkat1HomeScreen> createState() => _Tingkat1HomeScreenState();
// }

// class _Tingkat1HomeScreenState extends State<Tingkat1HomeScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _greetingController;
//   late AnimationController _bounceController;

//   @override
//   void initState() {
//     super.initState();
//     _greetingController = AnimationController(
//       duration: AppConstants.mediumAnimation,
//       vsync: this,
//     );
//     _bounceController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _greetingController.forward();
//     _bounceController.repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _greetingController.dispose();
//     _bounceController.dispose();
//     super.dispose();
//   }

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
//                 final balance = provider.getBalance(widget.user.id);
//                 final goals = provider.getSavingsGoalsForUser(widget.user.id);
//                 final missions =
//                     provider.getActiveMissionsForUser(widget.user.id);

//                 return RefreshIndicator(
//                   onRefresh: () async {
//                     // Add refresh logic here
//                     await Future.delayed(const Duration(seconds: 1));
//                   },
//                   child: SingleChildScrollView(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     padding: const EdgeInsets.all(AppConstants.spacing16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Greeting Section
//                         _buildGreetingSection(appProvider.currentTheme),

//                         Helpers.verticalSpace(AppConstants.spacing24),

//                         // Balance Card
//                         BalanceCard(
//                           balance: balance,
//                           ageTier: AgeTier.tingkat1,
//                           theme: appProvider.currentTheme,
//                           onTap: () => _showBalanceDetails(context, balance),
//                         ),

//                         Helpers.verticalSpace(AppConstants.spacing24),

//                         // Savings Goals Section
//                         if (goals.isNotEmpty) ...[
//                           _buildSectionTitle('🎯 Target Tabungan'),
//                           Helpers.verticalSpace(AppConstants.spacing12),
//                           SavingsGoalsCarousel(
//                             goals: goals,
//                             ageTier: AgeTier.tingkat1,
//                             theme: appProvider.currentTheme,
//                             onGoalTap: (goal) => _showGoalDetail(
//                                 context, goal, appProvider.currentTheme),
//                           ),
//                           Helpers.verticalSpace(AppConstants.spacing24),
//                         ],

//                         // Missions Section
//                         if (missions.isNotEmpty) ...[
//                           _buildSectionTitle('⭐ Misi Hari Ini'),
//                           Helpers.verticalSpace(AppConstants.spacing12),
//                           ...missions.take(3).map((mission) => Padding(
//                                 padding: const EdgeInsets.only(
//                                     bottom: AppConstants.spacing12),
//                                 child: MissionCard(
//                                   mission: mission,
//                                   ageTier: AgeTier.tingkat1,
//                                   theme: appProvider.currentTheme,
//                                   onComplete: () =>
//                                       _completeMission(mission.id),
//                                 ),
//                               )),
//                           Helpers.verticalSpace(AppConstants.spacing24),
//                         ],

//                         // Quick Actions
//                         QuickActions(
//                           ageTier: AgeTier.tingkat1,
//                           theme: appProvider.currentTheme,
//                           onActionTap: _handleQuickAction,
//                         ),

//                         Helpers.verticalSpace(AppConstants.spacing24),

//                         // Motivational Section
//                         _buildMotivationalSection(appProvider.currentTheme),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildGreetingSection(ThemeColor theme) {
//     final hour = DateTime.now().hour;
//     String greeting;
//     String emoji;

//     if (hour < 12) {
//       greeting = 'Selamat Pagi';
//       emoji = '🌅';
//     } else if (hour < 17) {
//       greeting = 'Selamat Siang';
//       emoji = '☀️';
//     } else {
//       greeting = 'Selamat Sore';
//       emoji = '🌆';
//     }

//     return FadeTransition(
//       opacity: _greetingController,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(AppConstants.spacing20),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               AppColors.getCurrentPrimary(theme),
//               AppColors.getCurrentAccent(theme),
//             ],
//           ),
//           borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.getCurrentPrimary(theme).withOpacity(0.3),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   emoji,
//                   style: const TextStyle(fontSize: 32),
//                 ),
//                 Helpers.horizontalSpace(AppConstants.spacing12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         greeting,
//                         style: const TextStyle(
//                           color: AppColors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       Text(
//                         widget.user.name,
//                         style: const TextStyle(
//                           color: AppColors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Helpers.verticalSpace(AppConstants.spacing12),
//             AnimatedTextKit(
//               animatedTexts: [
//                 TypewriterAnimatedText(
//                   'Ayo kita nabung dan selesaikan misi hari ini! 🎉',
//                   textStyle: const TextStyle(
//                     color: AppColors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                   ),
//                   speed: const Duration(milliseconds: 50),
//                 ),
//               ],
//               totalRepeatCount: 1,
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

//   Widget _buildMotivationalSection(ThemeColor theme) {
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
//           AnimatedBuilder(
//             animation: _bounceController,
//             builder: (context, child) {
//               return Transform.translate(
//                 offset: Offset(0, -10 * _bounceController.value),
//                 child: Text(
//                   '🌟',
//                   style: TextStyle(fontSize: 40),
//                 ),
//               );
//             },
//           ),
//           Helpers.verticalSpace(AppConstants.spacing12),
//           Text(
//             'Kamu Hebat!',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: AppColors.getCurrentPrimary(theme),
//             ),
//           ),
//           Helpers.verticalSpace(AppConstants.spacing8),
//           Text(
//             'Setiap rupiah yang kamu tabung adalah langkah menuju impianmu!',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 14,
//               color: AppColors.grey600,
//               height: 1.4,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showBalanceDetails(BuildContext context, double balance) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Consumer<AppProvider>(
//         builder: (context, provider, child) => Container(
//           padding: const EdgeInsets.all(AppConstants.spacing20),
//           decoration: const BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.vertical(
//               top: Radius.circular(AppConstants.radiusLarge),
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: AppColors.grey300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Helpers.verticalSpace(AppConstants.spacing20),
//               Text(
//                 '💰 Saldo Kamu',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.grey800,
//                 ),
//               ),
//               Helpers.verticalSpace(AppConstants.spacing16),
//               Text(
//                 Helpers.formatCurrency(balance),
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.getCurrentPrimary(provider.currentTheme),
//                 ),
//               ),
//               Helpers.verticalSpace(AppConstants.spacing16),
//               Text(
//                 'Uang yang sudah kamu kumpulkan dengan rajin menabung dan menyelesaikan misi!',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: AppColors.grey600,
//                 ),
//               ),
//               Helpers.verticalSpace(AppConstants.spacing24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _completeMission(String missionId) {
//     final provider = Provider.of<AppProvider>(context, listen: false);
//     provider.completeMission(missionId);

//     Helpers.showSnackBar(
//       context,
//       '🎉 Misi selesai! Kamu mendapat reward!',
//     );
//   }

//   void _handleQuickAction(String action) {
//     switch (action) {
//       case 'add_goal':
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => CreateSavingsGoalScreen(user: widget.user),
//           ),
//         );
//         break;
//       case 'view_missions':
//         // Navigate to missions tab instead of creating new page
//         if (widget.onTabChange != null) {
//           widget.onTabChange!(2); // Index 2 is for missions
//         } else {
//           // Fallback to navigation if callback is not available
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => Tingkat1MissionsScreen(user: widget.user),
//             ),
//           );
//         }
//         break;
//       case 'piggy_bank':
//         // Navigate to savings tab instead of creating new page
//         if (widget.onTabChange != null) {
//           widget.onTabChange!(1); // Index 1 is for savings/celengan
//         } else {
//           // Fallback to navigation if callback is not available
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => Tingkat1SavingsScreen(user: widget.user),
//             ),
//           );
//         }
//         break;
//       case 'ask_parent':
//         _showRequestParentDialog();
//         break;
//     }
//   }

//   void _showRequestParentDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: AppColors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//           ),
//           title: Column(
//             children: [
//               Text(
//                 '👨‍👩‍👧‍👦',
//                 style: const TextStyle(fontSize: 48),
//               ),
//               Helpers.verticalSpace(AppConstants.spacing12),
//               Text(
//                 'Minta Orangtua',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.grey800,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//           content: Text(
//             'Fitur untuk meminta sesuatu dari orangtua akan segera hadir!',
//             style: TextStyle(
//               fontSize: 14,
//               color: AppColors.grey600,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(
//                 'OK',
//                 style: TextStyle(color: AppColors.primary),
//               ),
//             ),
//           ],
//         );
//       },
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

//   void _showAddMoneyDialog(BuildContext context, SavingsGoal goal) {
//     final TextEditingController amountController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Consumer<AppProvider>(
//           builder: (context, appProvider, child) {
//             final availableMoney = appProvider.getBalance(widget.user.id);
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
//       final currentBalance = provider.getBalance(widget.user.id);
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
//         userId: widget.user.id,
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
