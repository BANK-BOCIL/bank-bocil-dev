// lib/src/providers/auth_provider.dart

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../models/user.dart'; // Pastikan model User sudah ada dan benar

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _auth.currentUser != null;

  Future<void> initialize() async {
    _setLoading(true);
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      await _fetchUserData(firebaseUser.uid);
    }
    _setLoading(false);
  }

  Future<void> _fetchUserData(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      _currentUser = User.fromFirestore(userDoc.data()!);
    } else {
      _currentUser = null;
    }
    notifyListeners();
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

  // PERBAIKAN: Mengembalikan User? dan menambahkan `age` sebagai parameter.
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
      await userCredential.user?.updateDisplayName(name);
      final String parentId = userCredential.user!.uid;
      final String childCode = _generateChildCode();

      final newUser = User(
        id: parentId,
        name: name,
        type: UserType.parent,
        age: age,
        ageTier: null,
        childCode: childCode,
        parentId: null,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
      await _firestore
          .collection('users')
          .doc(parentId)
          .set(newUser.toFirestore());

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

  // PERBAIKAN: Mengembalikan User? agar bisa langsung digunakan setelah login.
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

  Future<User?> loginChild({
    required String childCode,
    required String childName,
    required int age,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      // 1. Lakukan sign-in anonim DULU untuk mendapatkan UID yang stabil untuk perangkat ini
      final userCredential = await _auth.signInAnonymously();
      final childUid = userCredential.user!.uid;

      // 2. Cek apakah dokumen untuk UID ini sudah ada di Firestore
      final userDocRef = _firestore.collection('users').doc(childUid);
      final userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        // Jika user sudah ada, cukup load datanya
        _currentUser = User.fromFirestore(userDocSnapshot.data()!);
        // Anda bisa menambahkan logika update `lastLoginAt` di sini jika perlu
        await userDocRef.update({'lastLoginAt': DateTime.now()});
      } else {
        // Jika user belum ada, ini adalah pendaftaran pertama kali
        // Cari parent berdasarkan childCode
        final querySnapshot = await _firestore
            .collection('users')
            .where('role', isEqualTo: 'UserType.parent')
            .where('childCode', isEqualTo: childCode.toUpperCase())
            .limit(1)
            .get();

        if (querySnapshot.docs.isEmpty) {
          _setError('Kode anak tidak valid atau tidak ditemukan.');
          // Hapus user anonim yang baru dibuat karena pendaftaran gagal
          await userCredential.user?.delete();
          return null;
        }

        final parentDoc = querySnapshot.docs.first;
        final parentId = parentDoc.id;
        final ageTier = _getAgeTierFromAge(age);

        // Buat objek user baru
        final newUser = User(
          id: childUid, // Gunakan UID dari hasil sign-in anonim
          name: childName,
          type: UserType.child,
          parentId: parentId,
          age: age,
          ageTier: ageTier,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );

        // Simpan user baru ke Firestore
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
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  String _generateChildCode() {
    const chars =
        'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Menghindari karakter ambigu
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
