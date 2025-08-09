// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../models/user.dart';
// import '../../models/mission.dart';
// import '../../providers/app_provider.dart';
// import '../../core/constants.dart';
// import '../../core/helpers.dart';
// import '../../widgets/mission_card.dart';

// class Tingkat1MissionsScreen extends StatelessWidget {
//   final User user;

//   const Tingkat1MissionsScreen({
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
//                 final missions = provider.getMissionsForUser(user.id);
//                 final activeMissions = missions
//                     .where((m) => m.status == MissionStatus.active)
//                     .toList();
//                 final completedMissions = missions
//                     .where((m) => m.status == MissionStatus.completed)
//                     .toList();

//                 return SingleChildScrollView(
//                   padding: const EdgeInsets.all(AppConstants.spacing16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header
//                       _buildHeader(context, appProvider.currentTheme),

//                       Helpers.verticalSpace(AppConstants.spacing24),

//                       // Today's Missions
//                       if (activeMissions.isNotEmpty) ...[
//                         _buildSectionTitle('⭐ Misi Hari Ini'),
//                         Helpers.verticalSpace(AppConstants.spacing12),
//                         ...activeMissions.map((mission) => Padding(
//                               padding: const EdgeInsets.only(
//                                   bottom: AppConstants.spacing12),
//                               child: MissionCard(
//                                 mission: mission,
//                                 ageTier: AgeTier.tingkat1,
//                                 onComplete: () =>
//                                     _completeMission(context, mission.id),
//                                 onTap: () => _showMissionDetail(
//                                     context, mission, appProvider.currentTheme),
//                               ),
//                             )),
//                         Helpers.verticalSpace(AppConstants.spacing24),
//                       ],

//                       // Completed Missions
//                       if (completedMissions.isNotEmpty) ...[
//                         _buildSectionTitle('🏆 Misi Selesai'),
//                         Helpers.verticalSpace(AppConstants.spacing12),
//                         ...completedMissions.take(5).map((mission) => Padding(
//                               padding: const EdgeInsets.only(
//                                   bottom: AppConstants.spacing12),
//                               child: _buildCompletedMissionCard(
//                                   mission, appProvider.currentTheme),
//                             )),
//                         if (completedMissions.length > 5) ...[
//                           Consumer<AppProvider>(
//                             builder: (context, themeProvider, child) =>
//                                 TextButton(
//                               onPressed: () => _showAllCompletedMissions(
//                                   context, completedMissions),
//                               child: Text(
//                                 'Lihat Semua Misi Selesai (${completedMissions.length})',
//                                 style: TextStyle(
//                                   color: AppColors.getCurrentPrimary(
//                                       themeProvider.currentTheme),
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                         Helpers.verticalSpace(AppConstants.spacing24),
//                       ],

//                       // Mission Stats
//                       _buildMissionStats(
//                           completedMissions, appProvider.currentTheme),

//                       Helpers.verticalSpace(AppConstants.spacing24),

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
//                 '⭐',
//                 style: const TextStyle(fontSize: 32),
//               ),
//               Helpers.horizontalSpace(AppConstants.spacing12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Misi ${user.name}',
//                       style: const TextStyle(
//                         color: AppColors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Selesaikan misi dan dapatkan reward!',
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

//   Widget _buildCompletedMissionCard(Mission mission, ThemeColor theme) {
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
//               color: AppColors.getCurrentPrimary(theme).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
//             ),
//             child: Center(
//               child: Text(
//                 AppConstants.missionIcons[mission.iconName] ??
//                     AppConstants.missionIcons['default']!,
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
//                   mission.title,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.grey800,
//                   ),
//                 ),
//                 Text(
//                   'Selesai ${Helpers.formatDate(mission.completedAt!)}',
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
//               horizontal: AppConstants.spacing8,
//               vertical: AppConstants.spacing4,
//             ),
//             decoration: BoxDecoration(
//               color: AppColors.getCurrentPrimary(theme).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.monetization_on,
//                   size: 14,
//                   color: AppColors.getCurrentPrimary(theme),
//                 ),
//                 Helpers.horizontalSpace(AppConstants.spacing4),
//                 Text(
//                   Helpers.formatCurrency(mission.reward),
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.getCurrentPrimary(theme),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMissionStats(List<Mission> completedMissions, ThemeColor theme) {
//     final totalReward = completedMissions.fold<double>(
//       0.0,
//       (sum, mission) => sum + mission.reward,
//     );

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
//             '📊 Statistik Misi',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: AppColors.grey800,
//             ),
//           ),
//           Helpers.verticalSpace(AppConstants.spacing16),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildStatCard(
//                   '🏆',
//                   '${completedMissions.length}',
//                   'Misi Selesai',
//                   theme,
//                 ),
//               ),
//               Helpers.horizontalSpace(AppConstants.spacing12),
//               Expanded(
//                 child: _buildStatCard(
//                   '💰',
//                   Helpers.formatCurrency(totalReward),
//                   'Total Reward',
//                   theme,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(
//       String emoji, String value, String label, ThemeColor theme) {
//     return Container(
//       padding: const EdgeInsets.all(AppConstants.spacing16),
//       decoration: BoxDecoration(
//         color: AppColors.getCurrentSecondary(theme),
//         borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
//       ),
//       child: Column(
//         children: [
//           Text(emoji, style: const TextStyle(fontSize: 24)),
//           Helpers.verticalSpace(AppConstants.spacing8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: AppColors.getCurrentPrimary(theme),
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
//             '💡 Tips Menyelesaikan Misi',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: AppColors.grey800,
//             ),
//           ),
//           Helpers.verticalSpace(AppConstants.spacing12),
//           _buildTip('⏰', 'Kerjakan misi tepat waktu'),
//           _buildTip('💪', 'Lakukan dengan semangat'),
//           _buildTip('🤝', 'Minta bantuan jika perlu'),
//           _buildTip('🎉', 'Nikmati reward yang didapat'),
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

//   void _completeMission(BuildContext context, String missionId) {
//     final provider = Provider.of<AppProvider>(context, listen: false);
//     provider.completeMission(missionId);

//     // Show celebration animation/dialog
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               '🎉',
//               style: const TextStyle(fontSize: 64),
//             ),
//             Helpers.verticalSpace(AppConstants.spacing16),
//             Text(
//               'Selamat!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.getCurrentPrimary(
//                     Provider.of<AppProvider>(context, listen: false)
//                         .currentTheme),
//               ),
//             ),
//             Helpers.verticalSpace(AppConstants.spacing8),
//             Text(
//               'Kamu berhasil menyelesaikan misi dan mendapat reward!',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: AppColors.grey600,
//               ),
//             ),
//             Helpers.verticalSpace(AppConstants.spacing24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.getCurrentPrimary(
//                       Provider.of<AppProvider>(context, listen: false)
//                           .currentTheme),
//                   foregroundColor: AppColors.white,
//                 ),
//                 child: const Text('Yeay!'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showMissionDetail(
//       BuildContext context, Mission mission, ThemeColor theme) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.6,
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

//             // Mission Details
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
//                       AppConstants.missionIcons[mission.iconName] ??
//                           AppConstants.missionIcons['default']!,
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
//                         mission.title,
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.grey800,
//                         ),
//                       ),
//                       Text(
//                         mission.description,
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

//             // Reward and Deadline Info
//             Container(
//               padding: const EdgeInsets.all(AppConstants.spacing16),
//               decoration: BoxDecoration(
//                 color: AppColors.getCurrentSecondary(theme),
//                 borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.monetization_on,
//                           color: AppColors.getCurrentPrimary(theme)),
//                       Helpers.horizontalSpace(AppConstants.spacing8),
//                       Text(
//                         'Reward: ${Helpers.formatCurrency(mission.reward)}',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.getCurrentPrimary(theme),
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (mission.deadline != null) ...[
//                     Helpers.verticalSpace(AppConstants.spacing8),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.schedule,
//                           color: mission.isOverdue
//                               ? AppColors.error
//                               : AppColors.grey600,
//                         ),
//                         Helpers.horizontalSpace(AppConstants.spacing8),
//                         Text(
//                           'Deadline: ${Helpers.formatDateTime(mission.deadline!)}',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: mission.isOverdue
//                                 ? AppColors.error
//                                 : AppColors.grey600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ],
//               ),
//             ),

//             const Spacer(),

//             // Complete Button
//             if (mission.isActive) ...[
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     _completeMission(context, mission.id);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.getCurrentPrimary(theme),
//                     foregroundColor: AppColors.white,
//                     padding: const EdgeInsets.symmetric(
//                         vertical: AppConstants.spacing16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(AppConstants.radiusMedium),
//                     ),
//                   ),
//                   child: const Text('Selesaikan Misi',
//                       style: TextStyle(fontSize: 16)),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   void _showAllCompletedMissions(BuildContext context, List<Mission> missions) {
//     // Implement show all completed missions
//     Helpers.showSnackBar(context, 'Menampilkan semua misi selesai...');
//   }
// }
