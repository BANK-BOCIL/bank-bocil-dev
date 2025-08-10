// lib/src/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/user.dart';
import '../models/account.dart';
import '../models/transaction.dart' as app_transaction;
import '../models/mission.dart';
import '../models/savings_goal.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- User Methods ---
  Future<User?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? User.fromFirestore(doc.data()!) : null;
  }

  Future<void> setUser(User user) {
    return _db.collection('users').doc(user.id).set(user.toFirestore());
  }

  // --- Account Methods ---
  Future<void> createAccount(String userId) {
    final account = Account(
      userId: userId,
      balance: 0.0,
      lastUpdated: DateTime.now(),
    );
    return _db.collection('accounts').doc(userId).set(account.toFirestore());
  }

  // Listens for real-time updates on an account.
  Stream<Account?> getAccountStream(String userId) {
    return _db.collection('accounts').doc(userId).snapshots().map((doc) {
      return doc.exists ? Account.fromFirestore(doc) : null;
    });
  }

  Future<void> updateAccountBalance(String userId, double amount) {
    final accountRef = _db.collection('accounts').doc(userId);
    return accountRef.update({
      'balance': FieldValue.increment(amount),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // --- Parent-Specific Methods ---
  // Listens for real-time updates when children are added/removed.
  Stream<List<User>> getChildrenStream(String parentId) {
    return _db.collection('users')
        .where('parentId', isEqualTo: parentId)
        .snapshots()
        .handleError((e) {
      debugPrint('getChildrenStream error: $e'); // don’t crash UI
    })
        .map((snap) => snap.docs.map((d) => User.fromFirestore(d.data())).toList());
  }



  // --- Data Streams for Children ---
  Stream<List<Mission>> getMissionsStream(String userId) {
    return _db
        .collection('missions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Mission.fromFirestore(doc)).toList());
  }

  Stream<List<app_transaction.Transaction>> getTransactionsStream(String userId) {
    return _db
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => app_transaction.Transaction.fromFirestore(doc))
        .toList());
  }

  Stream<List<SavingsGoal>> getSavingsGoalsStream(String userId) {
    return _db
        .collection('savings_goals')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => SavingsGoal.fromFirestore(doc))
        .toList());
  }
}
