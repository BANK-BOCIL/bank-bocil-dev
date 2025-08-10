// lib/src/providers/auth_provider.dart

import 'dart:async';

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
  StreamSubscription<firebase_auth.User?>? _authSub;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _auth.currentUser != null;

  Future<void> initialize() async {
    await _authSub?.cancel();
    _authSub = _auth.authStateChanges().listen((fbUser) async {
      _setLoading(true);
      if (fbUser == null) {
        _currentUser = null;
        _setLoading(false);
        return;
      }
      // load our user doc
      final snap = await _firestore.collection('users').doc(fbUser.uid).get();
      _currentUser = snap.exists ? User.fromFirestore(snap.data()!) : null;
      _setLoading(false);
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
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

      await _firestore.collection('parentChildCodes').doc(childCode).set({
        'parentId': parentId,
        'createdAt': FieldValue.serverTimestamp(),
        'active': true,
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
      if (_currentUser?.childCode != null && _currentUser!.childCode!.isNotEmpty) {
        await _firestore.collection('parentChildCodes')
            .doc(_currentUser!.childCode!)
            .set({
          'parentId': _currentUser!.id,
          'parentName': _currentUser!.name,
          'createdAt': FieldValue.serverTimestamp(),
          'active': true,
        }, SetOptions(merge: true));
      }
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
      // Ensure signed-in FIRST (anonymous OK)
      firebase_auth.User? fb = _auth.currentUser;
      if (fb == null) {
        fb = (await _auth.signInAnonymously()).user;
      } else if (!fb.isAnonymous) {
        // parent logged in: swap to anonymous *immediately*
        await _auth.signOut();
        fb = (await _auth.signInAnonymously()).user;
      }
      final uid = fb!.uid;

      final db = FirebaseFirestore.instance;
      final code = childCode.trim().toUpperCase();

      // read parentId (needs auth, we have it)
      final codeSnap = await db.collection('parentChildCodes').doc(code).get();
      final parentId = codeSnap.data()?['parentId'] as String?;
      if (parentId == null) {
        _setError('Kode anak tidak valid atau tidak ditemukan');
        return null;
      }

      final normalized = childName.trim();
      final nameLower = normalized.toLowerCase().replaceAll(' ', '_');

      // fast name-claim (avoid querying other users)
      final claimRef = db.collection('parentChildCodes')
          .doc(code)
          .collection('claimedNames')
          .doc(nameLower);

      if ((await claimRef.get()).exists) {
        _setError('Nama "$normalized" sudah dipakai di keluarga ini. Coba variasi lain 🙏');
        return null;
      }

      await claimRef.set({
        'ownerUid': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final tier = _getAgeTierFromAge(age) ?? AgeTier.tingkat1;

      final childUser = User(
        id: uid,
        name: normalized,
        age: age,
        type: UserType.child,
        ageTier: tier,
        parentId: parentId,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      final userData = childUser.toFirestore()..['nameLower'] = nameLower;

      // create user + account with concrete timestamp (no null Timestamp)
      await db.collection('users').doc(uid).set(userData);
      await db.collection('accounts').doc(uid).set({
        'userId': uid,
        'balance': 0.0,
        'lastUpdated': Timestamp.now(),
      });

      _currentUser = childUser; // set immediately so UI can route without waiting a re-read
      notifyListeners();
      return childUser;
    } catch (e) {
      _setError('Gagal masuk: $e');
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

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
