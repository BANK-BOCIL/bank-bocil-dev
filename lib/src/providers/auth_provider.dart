// lib/src/providers/auth_provider.dart

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<void> initialize() async {
    _setLoading(true);
    // Dengarkan perubahan status auth secara real-time
    _auth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        _fetchUserData(firebaseUser.uid);
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
    _setLoading(false);
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        _currentUser = User.fromFirestore(userDoc.data()!);
      } else {
        _currentUser = null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      _currentUser = null;
    } finally {
      notifyListeners();
    }
  }

  AgeTier? _getAgeTierFromAge(int age) {
    if (age >= 6 && age <= 9) {
      return AgeTier.tingkat1;
    } else if (age >= 10 && age <= 12) {
      return AgeTier.tingkat2;
    } else if (age > 12) {
      return AgeTier.tingkat3;
    }
    return null;
  }

  Future<User?> registerParent({
    required String email,
    required String password,
    required String name,
    required int age,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final String parentId = userCredential.user!.uid;
      final String childCode = _generateChildCode();

      final newUser = User(
        id: parentId,
        name: name,
        type: UserType.parent,
        age: age,
        childCode: childCode,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      // Simpan data user parent
      await _firestore
          .collection('users')
          .doc(parentId)
          .set(newUser.toFirestore());

      // Simpan childCode untuk pencarian publik
      await _firestore.collection('parentChildCodes').doc(childCode).set({
        'parentId': parentId,
      });

      _currentUser = newUser;
      notifyListeners();
      return newUser;
    } on firebase_auth.FirebaseAuthException catch (e) {
      _setError(e.message ?? 'Gagal mendaftar.');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<User?> loginParent({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _fetchUserData(userCredential.user!.uid);
      return _currentUser;
    } on firebase_auth.FirebaseAuthException catch (e) {
      _setError(e.message ?? 'Gagal login.');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // --- FUNGSI LOGIN ANAK YANG SUDAH DIPERBAIKI ---
  Future<User?> loginChild({
    required String childCode,
    required String childName,
    required int age,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      // 1. Lakukan sign-in anonim DULU untuk mendapatkan sesi Auth yang nyata
      final userCredential = await _auth.signInAnonymously();
      final childUid = userCredential.user!.uid;

      // 2. Cek apakah dokumen untuk UID ini sudah ada di Firestore
      final userDocRef = _firestore.collection('users').doc(childUid);
      final userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        // Jika anak sudah pernah login di perangkat ini, cukup load datanya
        _currentUser = User.fromFirestore(userDocSnapshot.data()!);
        await userDocRef.update({'lastLoginAt': DateTime.now()});
      } else {
        // Jika ini login pertama kali di perangkat ini, buat dokumen baru
        final codeDoc = await _firestore
            .collection('parentChildCodes')
            .doc(childCode.toUpperCase())
            .get();

        if (!codeDoc.exists) {
          _setError('Kode anak tidak valid atau tidak ditemukan.');
          await userCredential.user?.delete(); // Hapus user anonim yang gagal
          return null;
        }

        final parentId = codeDoc.data()!['parentId'] as String;
        final ageTier = _getAgeTierFromAge(age);

        final newUser = User(
          id: childUid,
          name: childName,
          type: UserType.child,
          parentId: parentId,
          age: age,
          ageTier: ageTier,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );

        await userDocRef.set(newUser.toFirestore());
        _currentUser = newUser;
      }

      notifyListeners();
      return _currentUser;
    } catch (e) {
      _setError('Terjadi kesalahan saat login anak: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    // Sekarang logout berlaku untuk semua user karena semua punya sesi Auth
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  String _generateChildCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random.secure();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
