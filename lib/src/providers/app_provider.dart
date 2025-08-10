// lib/src/providers/app_provider.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/account.dart';
import '../models/transaction.dart' as local_transaction;
import '../models/savings_goal.dart';
import '../models/mission.dart';
import '../models/budget.dart';
import '../core/constants.dart';
import '../services/firestore_service.dart';

class AppProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  ThemeColor _currentTheme = ThemeColor.pink;

  Account? _parentAccount;
  List<Account> _childrenAccounts = [];
  List<User> _children = [];
  List<local_transaction.Transaction> _transactions = [];
  List<SavingsGoal> _savingsGoals = [];
  List<Mission> _missions = [];

  StreamSubscription? _parentAccountSubscription;
  StreamSubscription? _childrenSubscription;
  final Map<String, StreamSubscription> _childrenAccountSubscriptions = {};

  User? get currentUser => _currentUser;
  Account? get parentAccount => _parentAccount;
  List<Account> get childrenAccounts => _childrenAccounts;
  List<User> get children => _children;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ThemeColor get currentTheme => _currentTheme;

  double get totalFamilyBalance {
    return _childrenAccounts.fold(0.0, (sum, account) => sum + account.balance);
  }

  void listenToData(User user) {
    if (_currentUser?.id == user.id) return;

    _setLoading(true);
    _clearAllData();
    _currentUser = user;

    if (_currentUser!.type == UserType.parent) {
      _listenToParentData(_currentUser!.id);
    } else {
      // Logic for child user data can be added here
    }
    _setLoading(false);
  }

  // --- NEW: Method to safely clear data on logout ---
  void clearDataOnLogout() {
    _clearAllData();
  }

  void _listenToParentData(String parentId) {
    _parentAccountSubscription =
        _firestoreService.getAccountStream(parentId).listen((account) {
          _parentAccount = account;
          notifyListeners();
        });

    _childrenSubscription =
        _firestoreService.getChildrenStream(parentId).listen((childrenData) {
          _children = childrenData;
          _listenToChildrenAccounts(childrenData);
          notifyListeners();
        });
  }

  void _listenToChildrenAccounts(List<User> children) {
    final childrenIds = children.map((c) => c.id).toSet();

    _childrenAccountSubscriptions.keys
        .where((id) => !childrenIds.contains(id))
        .toList()
        .forEach((id) {
      _childrenAccountSubscriptions[id]?.cancel();
      _childrenAccountSubscriptions.remove(id);
      _childrenAccounts.removeWhere((acc) => acc.userId == id);
    });

    for (final child in children) {
      if (!_childrenAccountSubscriptions.containsKey(child.id)) {
        _childrenAccountSubscriptions[child.id] =
            _firestoreService.getAccountStream(child.id).listen((account) {
              _childrenAccounts.removeWhere((acc) => acc.userId == child.id);
              if (account != null) {
                _childrenAccounts.add(account);
              }
              notifyListeners();
            });
      }
    }
  }

  Future<void> addFundsToParentAccount(double amount) async {
    if (_currentUser == null || amount <= 0) return;
    _setLoading(true);
    try {
      await _firestoreService.updateAccountBalance(_currentUser!.id, amount);
    } catch (e) {
      _setError("Gagal menambahkan dana: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> transferFundsToChild(String childId, double amount) async {
    if (_currentUser == null ||
        amount <= 0 ||
        (_parentAccount?.balance ?? 0) < amount) {
      _setError("Dana tidak mencukupi atau jumlah tidak valid.");
      return;
    }
    _setLoading(true);
    try {
      await _firestoreService.updateAccountBalance(_currentUser!.id, -amount);
      await _firestoreService.updateAccountBalance(childId, amount);
    } catch (e) {
      _setError("Gagal mentransfer dana: $e");
    } finally {
      _setLoading(false);
    }
  }

  void _clearAllData() {
    _cancelSubscriptions();
    _children = [];
    _parentAccount = null;
    _childrenAccounts = [];
    _currentUser = null;
    notifyListeners();
  }

  void _cancelSubscriptions() {
    _parentAccountSubscription?.cancel();
    _childrenSubscription?.cancel();
    _childrenAccountSubscriptions.values.forEach((sub) => sub.cancel());
    _childrenAccountSubscriptions.clear();
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    super.dispose();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
}
