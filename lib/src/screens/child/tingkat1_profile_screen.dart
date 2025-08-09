// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../models/user.dart';
// import '../../models/savings_goal.dart';
// import '../../providers/app_provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../core/constants.dart';
// import '../../core/helpers.dart';
// import '../auth/auth_screen.dart';

// class Tingkat1ProfileScreen extends StatelessWidget {
//   final User user;

//   const Tingkat1ProfileScreen({
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
//                 final balance = provider.getBalance(user.id);
//                 final completedMissions = provider
//                     .getMissionsForUser(user.id)
//                     .where((m) => m.isCompleted)
//                     .length;
//                 final completedGoals = provider
//                     .getSavingsGoalsForUser(user.id)
//                     .where((g) => g.status == GoalStatus.completed)
//                     .length;

//                 return SingleChildScrollView(
//                   padding: const EdgeInsets.all(AppConstants.spacing16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Profile Header
//                       _buildProfileHeader(provider.currentTheme),

//                       Helpers.verticalSpace(AppConstants.spacing24),

//                       // Stats Cards
//                       _buildStatsSection(balance, completedMissions,
//                           completedGoals, provider.currentTheme),

//                       Helpers.verticalSpace(AppConstants.spacing24),

//                       // Settings
//                       _buildSettingsSection(context),
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

//   Widget _buildProfileHeader(ThemeColor theme) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(AppConstants.spacing24),
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
//         children: [
//           // Avatar
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(40),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Text(
//                 user.name.isNotEmpty ? user.name[0].toUpperCase() : '👤',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.getCurrentPrimary(theme),
//                 ),
//               ),
//             ),
//           ),

//           Helpers.verticalSpace(AppConstants.spacing16),

//           // Name and Age
//           Text(
//             user.name,
//             style: const TextStyle(
//               color: AppColors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),

//           Helpers.verticalSpace(AppConstants.spacing4),

//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: AppConstants.spacing12,
//               vertical: AppConstants.spacing4,
//             ),
//             decoration: BoxDecoration(
//               color: AppColors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
//             ),
//             child: Text(
//               '${user.age} tahun • Tingkat 1',
//               style: TextStyle(
//                 color: AppColors.white.withOpacity(0.9),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatsSection(double balance, int completedMissions,
//       int completedGoals, ThemeColor theme) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '📊 Statistik Kamu',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: AppColors.grey800,
//           ),
//         ),
//         Helpers.verticalSpace(AppConstants.spacing12),

//         // Achievements Section - now at the top and full width
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(AppConstants.spacing16),
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text('🏆', style: const TextStyle(fontSize: 20)),
//                   Helpers.horizontalSpace(AppConstants.spacing8),
//                   Text(
//                     'Pencapaian',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.grey800,
//                     ),
//                   ),
//                 ],
//               ),
//               Helpers.verticalSpace(AppConstants.spacing12),
//               Row(
//                 children: _getAchievements(completedMissions, completedGoals)
//                     .take(4) // Show only 4 achievements to fit in one row
//                     .map((achievement) => Expanded(
//                           child: Container(
//                             margin: const EdgeInsets.only(
//                                 right: AppConstants.spacing8),
//                             child: Column(
//                               children: [
//                                 Text(
//                                   achievement.isUnlocked
//                                       ? achievement.emoji
//                                       : '🔒',
//                                   style: const TextStyle(fontSize: 24),
//                                 ),
//                                 Helpers.verticalSpace(AppConstants.spacing4),
//                                 Text(
//                                   achievement.title,
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.w600,
//                                     color: achievement.isUnlocked
//                                         ? AppColors.grey800
//                                         : AppColors.grey500,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ))
//                     .toList(),
//               ),
//             ],
//           ),
//         ),

//         Helpers.verticalSpace(AppConstants.spacing12),

//         Row(
//           children: [
//             Expanded(
//               child: _buildStatCard(
//                 '💰',
//                 Helpers.formatCurrency(balance),
//                 'Total Saldo',
//                 AppColors.getCurrentPrimary(theme),
//               ),
//             ),
//             Helpers.horizontalSpace(AppConstants.spacing12),
//             Expanded(
//               child: _buildStatCard(
//                 '⭐',
//                 '$completedMissions',
//                 'Misi Selesai',
//                 AppColors.success,
//               ),
//             ),
//           ],
//         ),
//         Helpers.verticalSpace(AppConstants.spacing12),
//         SizedBox(
//           width: double.infinity,
//           child: _buildStatCard(
//             '🎯',
//             '$completedGoals Target Tercapai',
//             'Pencapaian',
//             AppColors.warning,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard(String emoji, String value, String label, Color color) {
//     return Container(
//       width: double.infinity,
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
//       child: Column(
//         children: [
//           Text(emoji, style: const TextStyle(fontSize: 24)),
//           Helpers.verticalSpace(AppConstants.spacing8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: AppColors.grey600,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingsSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '⚙️ Pengaturan',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: AppColors.grey800,
//           ),
//         ),
//         Helpers.verticalSpace(AppConstants.spacing12),
//         Container(
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               _buildNotificationToggle(context),
//               _buildDivider(),
//               _buildThemeSelector(context),
//               _buildDivider(),
//               _buildSettingItem(
//                 Icons.help_outline,
//                 'Bantuan',
//                 'Butuh bantuan? Tanya di sini',
//                 () => _showHelpDialog(context),
//               ),
//               _buildDivider(),
//               _buildSettingItem(
//                 Icons.info_outline,
//                 'Tentang Aplikasi',
//                 'Informasi Bank Bocil',
//                 () => _showAboutDialog(context),
//               ),
//               _buildDivider(),
//               _buildLogoutItem(context),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSettingItem(
//       IconData icon, String title, String subtitle, VoidCallback onTap) {
//     return Consumer<AppProvider>(
//       builder: (context, provider, child) {
//         return ListTile(
//           leading: Icon(icon,
//               color: AppColors.getCurrentPrimary(provider.currentTheme)),
//           title: Text(
//             title,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.grey800,
//             ),
//           ),
//           subtitle: Text(
//             subtitle,
//             style: TextStyle(
//               fontSize: 14,
//               color: AppColors.grey600,
//             ),
//           ),
//           trailing: Icon(
//             Icons.arrow_forward_ios,
//             color: AppColors.grey400,
//             size: 16,
//           ),
//           onTap: onTap,
//         );
//       },
//     );
//   }

//   Widget _buildDivider() {
//     return Divider(
//       height: 1,
//       thickness: 1,
//       color: AppColors.grey200,
//       indent: 16,
//       endIndent: 16,
//     );
//   }

//   Widget _buildNotificationToggle(BuildContext context) {
//     return Consumer<AppProvider>(
//       builder: (context, provider, child) {
//         final isNotificationEnabled = provider.isNotificationEnabled ?? true;
//         final currentTheme = provider.currentTheme;

//         return ListTile(
//           leading: Icon(
//             isNotificationEnabled
//                 ? Icons.notifications
//                 : Icons.notifications_off,
//             color: AppColors.getCurrentPrimary(currentTheme),
//           ),
//           title: Text(
//             'Notifikasi',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.grey800,
//             ),
//           ),
//           subtitle: Text(
//             isNotificationEnabled
//                 ? 'Pengingat dan pemberitahuan aktif'
//                 : 'Pengingat dan pemberitahuan nonaktif',
//             style: TextStyle(
//               fontSize: 14,
//               color: AppColors.grey600,
//             ),
//           ),
//           trailing: Switch(
//             value: isNotificationEnabled,
//             onChanged: (value) {
//               provider.toggleNotification(value);
//               _showNotificationStatus(context, value);
//             },
//             activeColor: AppColors.getCurrentPrimary(currentTheme),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildThemeSelector(BuildContext context) {
//     return Consumer<AppProvider>(
//       builder: (context, provider, child) {
//         final currentTheme = provider.currentTheme;
//         final themeData = AppConstants.themeOptions.firstWhere(
//           (theme) => theme['theme'] == currentTheme,
//           orElse: () => AppConstants.themeOptions[0],
//         );

//         return ListTile(
//           leading: Icon(
//             Icons.palette,
//             color: AppColors.getCurrentPrimary(currentTheme),
//           ),
//           title: Text(
//             'Tema Warna',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.grey800,
//             ),
//           ),
//           subtitle: Text(
//             '${themeData['emoji']} ${themeData['name']} - ${themeData['description']}',
//             style: TextStyle(
//               fontSize: 14,
//               color: AppColors.grey600,
//             ),
//           ),
//           trailing: Icon(
//             Icons.arrow_forward_ios,
//             color: AppColors.grey400,
//             size: 16,
//           ),
//           onTap: () => _showThemeDialog(context),
//         );
//       },
//     );
//   }

//   List<Achievement> _getAchievements(
//       int completedMissions, int completedGoals) {
//     return [
//       Achievement(
//         emoji: '🌟',
//         title: 'Pemula',
//         description: 'Selesaikan misi pertama',
//         isUnlocked: completedMissions >= 1,
//       ),
//       Achievement(
//         emoji: '🎯',
//         title: 'Penabung Cilik',
//         description: 'Capai target tabungan pertama',
//         isUnlocked: completedGoals >= 1,
//       ),
//       Achievement(
//         emoji: '💪',
//         title: 'Rajin Bekerja',
//         description: 'Selesaikan 5 misi',
//         isUnlocked: completedMissions >= 5,
//       ),
//       Achievement(
//         emoji: '🏆',
//         title: 'Master Nabung',
//         description: 'Capai 3 target tabungan',
//         isUnlocked: completedGoals >= 3,
//       ),
//     ];
//   }

//   void _showNotificationStatus(BuildContext context, bool isEnabled) {
//     final message = isEnabled
//         ? '🔔 Notifikasi telah diaktifkan!'
//         : '🔕 Notifikasi telah dinonaktifkan!';

//     Helpers.showSnackBar(context, message);
//   }

//   void _showThemeDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => Consumer<AppProvider>(
//         builder: (context, provider, child) => Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//           ),
//           child: Container(
//             width: double.infinity,
//             constraints: const BoxConstraints(maxHeight: 500),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Header
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(AppConstants.spacing20),
//                   decoration: BoxDecoration(
//                     color: AppColors.getCurrentPrimary(provider.currentTheme),
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(AppConstants.radiusLarge),
//                       topRight: Radius.circular(AppConstants.radiusLarge),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Text('🎨', style: const TextStyle(fontSize: 24)),
//                       Helpers.horizontalSpace(AppConstants.spacing8),
//                       const Text(
//                         'Pilih Tema Warna',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.white,
//                         ),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                         icon: const Icon(
//                           Icons.close,
//                           color: AppColors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Theme Options
//                 Flexible(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     padding: const EdgeInsets.all(AppConstants.spacing16),
//                     itemCount: AppConstants.themeOptions.length,
//                     itemBuilder: (context, index) {
//                       final themeOption = AppConstants.themeOptions[index];
//                       final isSelected =
//                           provider.currentTheme == themeOption['theme'];

//                       return Container(
//                         margin: const EdgeInsets.only(
//                             bottom: AppConstants.spacing12),
//                         decoration: BoxDecoration(
//                           color: AppColors.white,
//                           borderRadius:
//                               BorderRadius.circular(AppConstants.radiusMedium),
//                           border: Border.all(
//                             color: isSelected
//                                 ? AppColors.getCurrentPrimary(
//                                     themeOption['theme'])
//                                 : AppColors.grey200,
//                             width: isSelected ? 2 : 1,
//                           ),
//                         ),
//                         child: ListTile(
//                           leading: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: AppColors.getCurrentPrimary(
//                                   themeOption['theme']),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 themeOption['emoji'],
//                                 style: const TextStyle(fontSize: 20),
//                               ),
//                             ),
//                           ),
//                           title: Text(
//                             themeOption['name'],
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.grey800,
//                             ),
//                           ),
//                           subtitle: Text(
//                             themeOption['description'],
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: AppColors.grey600,
//                             ),
//                           ),
//                           trailing: isSelected
//                               ? Icon(
//                                   Icons.check_circle,
//                                   color: AppColors.getCurrentPrimary(
//                                       themeOption['theme']),
//                                 )
//                               : null,
//                           onTap: () {
//                             provider.changeTheme(themeOption['theme']);
//                             Navigator.of(context).pop();
//                             _showThemeChangeStatus(
//                                 context, themeOption['name']);
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showThemeChangeStatus(BuildContext context, String themeName) {
//     Helpers.showSnackBar(context, '🎨 Tema berhasil diubah ke $themeName!');
//   }

//   void _showHelpDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => Consumer<AppProvider>(
//         builder: (context, provider, child) => Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//           ),
//           child: Container(
//             width: double.infinity,
//             constraints: const BoxConstraints(maxHeight: 600),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Header
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(AppConstants.spacing20),
//                   decoration: BoxDecoration(
//                     color: AppColors.getCurrentPrimary(provider.currentTheme),
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(AppConstants.radiusLarge),
//                       topRight: Radius.circular(AppConstants.radiusLarge),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Text('❓', style: const TextStyle(fontSize: 24)),
//                       Helpers.horizontalSpace(AppConstants.spacing8),
//                       const Text(
//                         'Bantuan',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.white,
//                         ),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                         icon: const Icon(
//                           Icons.close,
//                           color: AppColors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Content
//                 Flexible(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(AppConstants.spacing20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // FAQ Section
//                         Text(
//                           '❓ Pertanyaan yang Sering Ditanyakan',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.grey800,
//                           ),
//                         ),
//                         Helpers.verticalSpace(AppConstants.spacing12),

//                         ..._getFAQItems().map(
//                             (faq) => _buildFAQItem(faq, provider.currentTheme)),

//                         Helpers.verticalSpace(AppConstants.spacing24),

//                         // Contact Section
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(AppConstants.spacing16),
//                           decoration: BoxDecoration(
//                             color: AppColors.getCurrentSecondary(
//                                     provider.currentTheme)
//                                 .withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(
//                                 AppConstants.radiusMedium),
//                           ),
//                           child: Column(
//                             children: [
//                               Text(
//                                 '💬 Masih Butuh Bantuan?',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.grey800,
//                                 ),
//                               ),
//                               Helpers.verticalSpace(AppConstants.spacing8),
//                               Text(
//                                 'Hubungi kami melalui WhatsApp untuk bantuan lebih lanjut',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: AppColors.grey600,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               Helpers.verticalSpace(AppConstants.spacing16),
//                               ElevatedButton.icon(
//                                 onPressed: () => _openWhatsApp(context),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor:
//                                       const Color(0xFF25D366), // WhatsApp green
//                                   foregroundColor: AppColors.white,
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: AppConstants.spacing20,
//                                     vertical: AppConstants.spacing12,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(
//                                         AppConstants.radiusMedium),
//                                   ),
//                                 ),
//                                 icon: const Icon(Icons.chat, size: 20),
//                                 label: const Text(
//                                   'Chat WhatsApp',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showAboutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => Consumer<AppProvider>(
//         builder: (context, provider, child) => AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//           ),
//           title: Row(
//             children: [
//               Text('🏦', style: const TextStyle(fontSize: 24)),
//               Helpers.horizontalSpace(AppConstants.spacing8),
//               const Text('Bank Bocil'),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Versi ${AppConstants.appVersion}',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.grey800,
//                 ),
//               ),
//               Helpers.verticalSpace(AppConstants.spacing8),
//               Text(
//                 'Aplikasi edukasi keuangan untuk anak-anak. Belajar menabung dengan cara yang menyenangkan!',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: AppColors.grey600,
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(
//                 'OK',
//                 style: TextStyle(
//                     color: AppColors.getCurrentPrimary(provider.currentTheme)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<FAQItem> _getFAQItems() {
//     return [
//       FAQItem(
//         question: 'Bagaimana cara menabung?',
//         answer:
//             'Kamu bisa menabung dengan menyelesaikan misi-misi yang tersedia. Setiap misi yang selesai akan memberikan reward uang yang masuk ke tabunganmu!',
//       ),
//       FAQItem(
//         question: 'Apa itu target tabungan?',
//         answer:
//             'Target tabungan adalah tujuan menabungmu. Kamu bisa membuat target untuk membeli mainan atau barang yang kamu inginkan. Terus kumpulkan uang sampai targetmu tercapai!',
//       ),
//       FAQItem(
//         question: 'Bagaimana cara menyelesaikan misi?',
//         answer:
//             'Baca instruksi misi dengan baik, lalu lakukan tugasnya. Setelah selesai, minta orang tua untuk mengonfirmasi bahwa kamu sudah menyelesaikan misi tersebut.',
//       ),
//       FAQItem(
//         question: 'Kapan uang bisa diambil?',
//         answer:
//             'Uang bisa diambil ketika target tabunganmu sudah tercapai. Minta bantuan orang tua untuk mengambil uang dari tabungan nyata.',
//       ),
//       FAQItem(
//         question: 'Apakah aplikasi ini aman?',
//         answer:
//             'Ya! Bank Bocil adalah aplikasi edukasi yang aman. Semua data disimpan dengan aman dan hanya orang tua yang bisa mengontrol tabungan sesungguhnya.',
//       ),
//     ];
//   }

//   Widget _buildFAQItem(FAQItem faq, ThemeColor theme) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: AppConstants.spacing12),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
//         border: Border.all(color: AppColors.grey200),
//       ),
//       child: ExpansionTile(
//         tilePadding: const EdgeInsets.symmetric(
//           horizontal: AppConstants.spacing16,
//           vertical: AppConstants.spacing4,
//         ),
//         childrenPadding: const EdgeInsets.fromLTRB(
//           AppConstants.spacing16,
//           0,
//           AppConstants.spacing16,
//           AppConstants.spacing16,
//         ),
//         title: Text(
//           faq.question,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: AppColors.grey800,
//           ),
//         ),
//         iconColor: AppColors.getCurrentPrimary(theme),
//         collapsedIconColor: AppColors.grey600,
//         children: [
//           Text(
//             faq.answer,
//             style: TextStyle(
//               fontSize: 13,
//               color: AppColors.grey600,
//               height: 1.4,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _openWhatsApp(BuildContext context) async {
//     const phoneNumber = '+6281234567890';
//     try {
//       _showWhatsAppInfo(context, phoneNumber);
//     } catch (e) {
//       _showWhatsAppInfo(context, phoneNumber);
//     }
//   }

//   void _showWhatsAppInfo(BuildContext context, String phoneNumber) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) => Consumer<AppProvider>(
//         builder: (context, provider, child) => AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//           ),
//           title: Row(
//             children: [
//               Icon(Icons.chat, color: const Color(0xFF25D366)),
//               Helpers.horizontalSpace(AppConstants.spacing8),
//               const Text('Hubungi WhatsApp'),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Untuk bantuan lebih lanjut, hubungi kami di:',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: AppColors.grey600,
//                 ),
//               ),
//               Helpers.verticalSpace(AppConstants.spacing8),
//               Container(
//                 padding: const EdgeInsets.all(AppConstants.spacing12),
//                 decoration: BoxDecoration(
//                   color: AppColors.grey100,
//                   borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.phone, color: AppColors.grey600, size: 16),
//                     Helpers.horizontalSpace(AppConstants.spacing8),
//                     Text(
//                       phoneNumber,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.grey800,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Helpers.verticalSpace(AppConstants.spacing8),
//               Text(
//                 'Atau cari "Bank Bocil Support" di WhatsApp',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: AppColors.grey500,
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(dialogContext).pop(),
//               child: Text(
//                 'OK',
//                 style: TextStyle(
//                     color: AppColors.getCurrentPrimary(provider.currentTheme)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLogoutItem(BuildContext context) {
//     return Consumer<AppProvider>(
//       builder: (context, provider, child) {
//         return ListTile(
//           leading: Icon(
//             Icons.logout,
//             color: AppColors.error,
//           ),
//           title: Text(
//             'Keluar',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.error,
//             ),
//           ),
//           subtitle: Text(
//             'Keluar dari akun saat ini',
//             style: TextStyle(
//               fontSize: 14,
//               color: AppColors.grey600,
//             ),
//           ),
//           trailing: Icon(
//             Icons.arrow_forward_ios,
//             color: AppColors.grey400,
//             size: 16,
//           ),
//           onTap: () => _showLogoutConfirmation(context),
//         );
//       },
//     );
//   }

//   void _showLogoutConfirmation(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) => AlertDialog(
//         backgroundColor: AppColors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//         ),
//         title: Row(
//           children: [
//             Icon(
//               Icons.logout,
//               color: AppColors.error,
//               size: 24,
//             ),
//             Helpers.horizontalSpace(AppConstants.spacing8),
//             Text(
//               'Konfirmasi Keluar',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.grey800,
//               ),
//             ),
//           ],
//         ),
//         content: Text(
//           'Apakah kamu yakin ingin keluar dari akun ini? Kamu perlu masuk lagi untuk menggunakan aplikasi.',
//           style: TextStyle(
//             fontSize: 14,
//             color: AppColors.grey600,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(dialogContext).pop(),
//             child: Text(
//               'Batal',
//               style: TextStyle(
//                 color: AppColors.grey600,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.of(dialogContext).pop();
//               await _handleLogout(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.error,
//               foregroundColor: AppColors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
//               ),
//             ),
//             child: Text('Keluar'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _handleLogout(BuildContext context) async {
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.logout();

//       if (context.mounted) {
//         // Navigate to auth screen and clear all previous routes
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(
//             builder: (context) => const AuthScreen(),
//           ),
//           (route) => false,
//         );
//       }
//     } catch (e) {
//       if (context.mounted) {
//         Helpers.showSnackBar(context, 'Gagal keluar dari akun: $e');
//       }
//     }
//   }
// }

// class FAQItem {
//   final String question;
//   final String answer;

//   FAQItem({
//     required this.question,
//     required this.answer,
//   });
// }

// class Achievement {
//   final String emoji;
//   final String title;
//   final String description;
//   final bool isUnlocked;

//   Achievement({
//     required this.emoji,
//     required this.title,
//     required this.description,
//     required this.isUnlocked,
//   });
// }
