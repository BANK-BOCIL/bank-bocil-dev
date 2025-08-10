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
import '../models/mission.dart';
import 'package:flutter/foundation.dart';

class AppProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  ThemeColor _currentTheme = ThemeColor.pink;
  bool _notificationsEnabled = true;

  Account? _parentAccount;
  List<Account> _childrenAccounts = [];
  List<User> _children = [];
  List<local_transaction.Transaction> _transactions = [];
  List<SavingsGoal> _savingsGoals = [];
  List<Mission> _missions = [];

  StreamSubscription? _parentAccountSubscription;
  StreamSubscription? _childrenSubscription;
  StreamSubscription? _childGoalsSub;
  StreamSubscription? _childMissionsSub;
  StreamSubscription? _childTxSub;
  final Map<String, StreamSubscription> _childrenAccountSubscriptions = {};
  final Map<String, StreamSubscription> _childrenMissionsSubscriptions = {};
  final Map<String, StreamSubscription> _childrenTxSubscriptions = {};

  User? get currentUser => _currentUser;
  Account? get parentAccount => _parentAccount;
  List<Account> get childrenAccounts => _childrenAccounts;
  List<User> get children => _children;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ThemeColor get currentTheme => _currentTheme;
  bool get isNotificationEnabled => _notificationsEnabled;

  double get totalFamilyBalance {
    return _childrenAccounts.fold(0.0, (sum, account) => sum + account.balance);
  }

  int get childrenCount => _children.length;

  double get householdBalance =>
      (_parentAccount?.balance ?? 0.0) +
          _childrenAccounts.fold(0.0, (sum, a) => sum + a.balance);

  double get totalIncomeThisMonth {
    final now = DateTime.now();
    return _transactions.where((t) =>
    t.type == local_transaction.TransactionType.income &&
        t.createdAt.year == now.year &&
        t.createdAt.month == now.month
    ).fold(0.0, (sum, t) => sum + t.amount);
  }

  double getBalance(String userId) {
    if (_parentAccount?.userId == userId) return _parentAccount?.balance ?? 0.0;
    final acc = _childrenAccounts.firstWhere(
          (a) => a.userId == userId,
      orElse: () => Account(userId: '', balance: 0, lastUpdated: DateTime.now()),
    );
    return acc.balance;
  }

  List<SavingsGoal> getSavingsGoalsForUser(String userId) =>
      _savingsGoals.where((g) => g.userId == userId).toList();

  List<Mission> getActiveMissionsForUser(String userId) =>
      _missions.where((m) =>
      m.userId == userId && m.status == MissionStatus.active).toList();

  List<Mission> getMissionsForUser(String userId) =>
      _missions.where((m) => m.userId == userId).toList();


  Future<void> completeMission(String missionId) async {
    try {
      await _firestoreService.updateMissionStatus(
        missionId,
        MissionStatus.completed.name, // "completed"
      );
    } catch (e) {
      _setError('Gagal menyelesaikan misi: $e');
    }
  }

  Future<void> addTransaction(local_transaction.Transaction tx) async {
    try {
      await _firestoreService.addTransaction(tx);
      // reflect balance
      final delta = tx.type == local_transaction.TransactionType.expense
          ? -tx.amount
          : tx.amount;
      await _firestoreService.updateAccountBalance(tx.userId, delta);
    } catch (e) {
      _setError('Gagal menambah transaksi: $e');
    }
  }

  Future<void> addSavingsGoal(SavingsGoal goal) async {
    try {
      // write to Firestore
      await _firestoreService.createSavingsGoal(goal);

      // Optimistic UI update (stream will also refresh this list shortly)
      _savingsGoals.removeWhere((g) => g.id == goal.id);
      _savingsGoals.add(goal);
      notifyListeners();
    } catch (e) {
      _setError('Gagal membuat target tabungan: $e');
    }
  }

  Future<void> updateSavingsGoal(SavingsGoal goal) async {
    try {
      await _firestoreService.updateSavingsGoal(goal);
    } catch (e) {
      _setError('Gagal memperbarui target tabungan: $e');
    }
  }

  void listenToData(User user) {
    if (_currentUser?.id == user.id) return;
    _setLoading(true);
    _clearAllData();
    _currentUser = user;

    // kick off async load of stored prefs (theme/notifications)
    _loadUserPrefs(user.id);

    if (_currentUser!.type == UserType.parent) {
      _listenToParentData(_currentUser!.id);
    } else {
      _listenToChildData(_currentUser!.id);
    }
    _setLoading(false);
  }

  Future<void> _loadUserPrefs(String uid) async {
    try {
      final data = await _firestoreService.getUserPrefs(uid);
      if (data != null) {
        final themeStr = data['theme'] as String?;
        if (themeStr != null) {
          try {
            _currentTheme = ThemeColor.values
                .firstWhere((t) => describeEnum(t) == themeStr);
          } catch (_) {/* keep default if parsing fails */}
        }
        final notif = data['notificationsEnabled'];
        if (notif is bool) _notificationsEnabled = notif;
        notifyListeners();
      }
    } catch (_) {
      // ignore – prefs are optional
    }
  }

  Future<void> toggleNotification(bool value) async {
    _notificationsEnabled = value;
    notifyListeners();
    if (_currentUser != null) {
      await _firestoreService.updateUserSettings(
        _currentUser!.id,
        {'notificationsEnabled': value},
      );
    }
  }

  Future<void> changeTheme(ThemeColor theme) async {
    if (_currentTheme == theme) return;
    _currentTheme = theme;
    notifyListeners();
    if (_currentUser != null) {
      await _firestoreService.updateUserSettings(
        _currentUser!.id,
        {'theme': describeEnum(theme)},
      );
    }
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
          _listenToChildrenData(childrenData);
          notifyListeners();
        });
  }

  void _cancelSubscriptions() {
    _parentAccountSubscription?.cancel();
    _childrenSubscription?.cancel();
    _childGoalsSub?.cancel();
    _childMissionsSub?.cancel();
    _childTxSub?.cancel();
    _childrenAccountSubscriptions.values.forEach((sub) => sub.cancel());
    _childrenAccountSubscriptions.clear();
    _childrenMissionsSubscriptions.values.forEach((s) => s.cancel());
    _childrenMissionsSubscriptions.clear();
    _childrenTxSubscriptions.values.forEach((s) => s.cancel());
    _childrenTxSubscriptions.clear();

  }


  void _listenToChildData(String userId) {
    // account
    _parentAccountSubscription =
        _firestoreService.getAccountStream(userId).listen((account) {
          _parentAccount = account; // reuse as "current account"
          notifyListeners();
        });

    // goals
    _childGoalsSub =
        _firestoreService.getSavingsGoalsStream(userId).listen((goals) {
          _savingsGoals = goals;
          notifyListeners();
        });

    // missions
    _childMissionsSub =
        _firestoreService.getMissionsStream(userId).listen((missions) {
          _missions = missions;
          notifyListeners();
        });

    // transactions
    _childTxSub =
        _firestoreService.getTransactionsStream(userId).listen((txs) {
          _transactions = txs;
          notifyListeners();
        });
  }

  void _listenToChildrenData(List<User> children) {
    final childrenIds = children.map((c) => c.id).toSet();

    // Cleanup removed children subscriptions
    for (final id in _childrenAccountSubscriptions.keys.toList()) {
      if (!childrenIds.contains(id)) {
        _childrenAccountSubscriptions[id]?.cancel();
        _childrenAccountSubscriptions.remove(id);
        _childrenAccounts.removeWhere((acc) => acc.userId == id);
      }
    }
    for (final id in _childrenMissionsSubscriptions.keys.toList()) {
      if (!childrenIds.contains(id)) {
        _childrenMissionsSubscriptions[id]?.cancel();
        _childrenMissionsSubscriptions.remove(id);
        _missions.removeWhere((m) => m.userId == id);
      }
    }
    for (final id in _childrenTxSubscriptions.keys.toList()) {
      if (!childrenIds.contains(id)) {
        _childrenTxSubscriptions[id]?.cancel();
        _childrenTxSubscriptions.remove(id);
        _transactions.removeWhere((t) => t.userId == id);
      }
    }

    // Add / update subscriptions for each child
    for (final child in children) {
      // Accounts
      _childrenAccountSubscriptions[child.id] ??=
          _firestoreService.getAccountStream(child.id).listen((account) {
            _childrenAccounts.removeWhere((a) => a.userId == child.id);
            if (account != null) _childrenAccounts.add(account);
            notifyListeners();
          });

      // Missions
      _childrenMissionsSubscriptions[child.id] ??=
          _firestoreService.getMissionsStream(child.id).listen((missions) {
            _missions.removeWhere((m) => m.userId == child.id);
            _missions.addAll(missions);
            notifyListeners();
          });

      // Transactions
      _childrenTxSubscriptions[child.id] ??=
          _firestoreService.getTransactionsStream(child.id).listen((txs) {
            _transactions.removeWhere((t) => t.userId == child.id);
            _transactions.addAll(txs);
            notifyListeners();
          });
    }
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
    _savingsGoals = [];
    _missions = [];
    _transactions = [];
    notifyListeners();
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
