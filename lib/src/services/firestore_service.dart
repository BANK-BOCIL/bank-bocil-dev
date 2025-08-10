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

  // FirestoreService.setUser
  Future<void> setUser(User user) {
    final data = user.toFirestore();
    data['nameLower'] = user.name.trim().toLowerCase();
    return _db.collection('users').doc(user.id).set(data);
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

  Future<void> createSavingsGoal(SavingsGoal goal) async {
    // keep the provided id if you passed one; otherwise generate one
    final goals = _db.collection('savings_goals');
    final docId = goal.id ?? goals.doc().id;
    await goals.doc(docId).set(
      goal.copyWith(id: docId).toFirestore(),
      SetOptions(merge: false),
    );
  }

  Stream<Account?> getAccountStream(String userId) {
    return _db.collection('accounts').doc(userId).snapshots().map((doc) {
      try {
        return doc.exists ? Account.fromFirestore(doc) : null;
      } catch (e) {
        debugPrint('Account parse error ($userId): $e');
        return null;
      }
    });
  }



  Future<void> updateSavingsGoal(SavingsGoal goal) async {
    final ref = _db.collection('savings_goals')
        .doc(goal.id ?? _db.collection('savings_goals').doc().id);
    await ref.set(goal.toFirestore(), SetOptions(merge: true));
  }

  Future<void> updateMissionStatus(String missionId, String status) async {
    await _db.collection('missions').doc(missionId).update({
      'status': status, // e.g., 'completed'
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addTransaction(app_transaction.Transaction tx) async {
    final ref = _db.collection('transactions').doc(tx.id);
    await ref.set(tx.toFirestore());
  }

  Future<void> updateUserSettings(String userId, Map<String, dynamic> data) {
    return _db.collection('users').doc(userId).set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserPrefs(String userId) async {
    final snap = await _db.collection('users').doc(userId).get();
    return snap.data();
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
