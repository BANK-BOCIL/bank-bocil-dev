// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// PERBAIKAN 1: Tambahkan impor yang hilang
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

// PERBAIKAN: Impor provider dan layar yang dibutuhkan
import 'src/app.dart'; // Asumsi MyApp ada di file ini
import 'src/providers/app_provider.dart';
import 'src/providers/auth_provider.dart';

import 'firebase_options.dart';

void main() async {
  // Pastikan semua binding siap sebelum menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi SettingsController
  final settingsController = SettingsController(SettingsService());

  // Muat pengaturan tema pengguna
  await settingsController.loadSettings();

  // PERBAIKAN 3: Menjalankan aplikasi dengan struktur yang benar
  runApp(
    // Bungkus aplikasi dengan MultiProvider untuk state management
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      // Kirim settingsController ke MyApp
      child: MyApp(settingsController: settingsController),
    ),
  );
}
