import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/transaction.dart';
import '../models/savings_goal.dart';
import '../models/mission.dart';
import '../models/budget.dart';
import '../core/constants.dart';

class AppProvider extends ChangeNotifier {
  // Initialization flag
  bool _isDataInitialized = false;
  bool get isDataInitialized => _isDataInitialized;

  // Current User
  User? _currentUser;
  User? get currentUser {
    if (!_isDataInitialized) {
      _initializeSampleDataSilently();
    }
    return _currentUser;
  }

  // Children (for parent users)
  List<User> _children = [];
  List<User> get children => _children;

  // Transactions
  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  // Savings Goals
  List<SavingsGoal> _savingsGoals = [];
  List<SavingsGoal> get savingsGoals => _savingsGoals;

  // Missions
  List<Mission> _missions = [];
  List<Mission> get missions => _missions;

  // Budgets
  List<Budget> _budgets = [];
  List<Budget> get budgets => _budgets;

  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error state
  String? _error;
  String? get error => _error;

  // Notification settings
  bool? _isNotificationEnabled = true;
  bool? get isNotificationEnabled => _isNotificationEnabled;

  // Theme settings
  ThemeColor _currentTheme = ThemeColor.pink;
  ThemeColor get currentTheme => _currentTheme;

  // Set current user
  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  // User methods
  void addChild(User child) {
    _children.add(child);
    notifyListeners();
  }

  void updateChild(User updatedChild) {
    final index = _children.indexWhere((child) => child.id == updatedChild.id);
    if (index != -1) {
      _children[index] = updatedChild;
      notifyListeners();
    }
  }

  void removeChild(String childId) {
    _children.removeWhere((child) => child.id == childId);
    notifyListeners();
  }

  // Transaction methods
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  void updateTransaction(Transaction updatedTransaction) {
    final index =
        _transactions.indexWhere((t) => t.id == updatedTransaction.id);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      notifyListeners();
    }
  }

  void removeTransaction(String transactionId) {
    _transactions.removeWhere((t) => t.id == transactionId);
    notifyListeners();
  }

  List<Transaction> getTransactionsForUser(String userId) {
    return _transactions.where((t) => t.userId == userId).toList();
  }

  List<Transaction> getPendingTransactions() {
    return _transactions
        .where((t) => t.status == TransactionStatus.pending)
        .toList();
  }

  double getBalance(String userId) {
    final userTransactions = getTransactionsForUser(userId);
    double balance = 0;

    for (final transaction in userTransactions) {
      if (transaction.status == TransactionStatus.completed) {
        switch (transaction.type) {
          case TransactionType.income:
          case TransactionType.allowance:
          case TransactionType.mission_reward:
            balance += transaction.amount;
            break;
          case TransactionType.expense:
            balance -= transaction.amount;
            break;
          case TransactionType.transfer:
            // Handle transfers based on context
            break;
        }
      }
    }

    return balance;
  }

  // Savings Goal methods
  void addSavingsGoal(SavingsGoal goal) {
    _savingsGoals.add(goal);
    notifyListeners();
  }

  void updateSavingsGoal(SavingsGoal updatedGoal) {
    final index = _savingsGoals.indexWhere((g) => g.id == updatedGoal.id);
    if (index != -1) {
      _savingsGoals[index] = updatedGoal;
      notifyListeners();
    }
  }

  void removeSavingsGoal(String goalId) {
    _savingsGoals.removeWhere((g) => g.id == goalId);
    notifyListeners();
  }

  List<SavingsGoal> getSavingsGoalsForUser(String userId) {
    return _savingsGoals.where((g) => g.userId == userId).toList();
  }

  void addToSavingsGoal(String goalId, double amount) {
    final goalIndex = _savingsGoals.indexWhere((g) => g.id == goalId);
    if (goalIndex != -1) {
      final goal = _savingsGoals[goalIndex];
      final newAmount = goal.currentAmount + amount;
      final updatedGoal = goal.copyWith(
        currentAmount: newAmount,
        status:
            newAmount >= goal.targetAmount ? GoalStatus.completed : goal.status,
        completedAt:
            newAmount >= goal.targetAmount ? DateTime.now() : goal.completedAt,
      );
      _savingsGoals[goalIndex] = updatedGoal;
      notifyListeners();
    }
  }

  // Mission methods
  void addMission(Mission mission) {
    _missions.add(mission);
    notifyListeners();
  }

  void updateMission(Mission updatedMission) {
    final index = _missions.indexWhere((m) => m.id == updatedMission.id);
    if (index != -1) {
      _missions[index] = updatedMission;
      notifyListeners();
    }
  }

  void removeMission(String missionId) {
    _missions.removeWhere((m) => m.id == missionId);
    notifyListeners();
  }

  List<Mission> getMissionsForUser(String userId) {
    return _missions.where((m) => m.userId == userId).toList();
  }

  List<Mission> getActiveMissionsForUser(String userId) {
    return _missions
        .where((m) => m.userId == userId && m.status == MissionStatus.active)
        .toList();
  }

  void completeMission(String missionId) {
    final missionIndex = _missions.indexWhere((m) => m.id == missionId);
    if (missionIndex != -1) {
      final mission = _missions[missionIndex];
      final completedMission = mission.copyWith(
        status: MissionStatus.completed,
        completedAt: DateTime.now(),
      );
      _missions[missionIndex] = completedMission;

      // Add reward transaction
      final rewardTransaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: mission.userId,
        parentId: mission.parentId,
        type: TransactionType.mission_reward,
        amount: mission.reward,
        description: 'Reward: ${mission.title}',
        status: TransactionStatus.completed,
        createdAt: DateTime.now(),
        missionId: missionId,
      );

      addTransaction(rewardTransaction);
      notifyListeners();
    }
  }

  // Budget methods
  void addBudget(Budget budget) {
    _budgets.add(budget);
    notifyListeners();
  }

  void updateBudget(Budget updatedBudget) {
    final index = _budgets.indexWhere((b) => b.id == updatedBudget.id);
    if (index != -1) {
      _budgets[index] = updatedBudget;
      notifyListeners();
    }
  }

  void removeBudget(String budgetId) {
    _budgets.removeWhere((b) => b.id == budgetId);
    notifyListeners();
  }

  List<Budget> getBudgetsForUser(String userId) {
    return _budgets.where((b) => b.userId == userId && b.isActive).toList();
  }

  // Utility methods
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Notification methods
  void toggleNotification(bool enabled) {
    _isNotificationEnabled = enabled;
    notifyListeners();

    // Here you could add logic to actually enable/disable push notifications
    // For example, using firebase_messaging or local_notifications packages
  }

  // Theme methods
  void changeTheme(ThemeColor newTheme) {
    _currentTheme = newTheme;
    notifyListeners();
  }

  // Initialize with sample data for demo
  void initializeSampleData() {
    _initializeSampleDataSilently();
    notifyListeners();
  }

  // Initialize data without triggering notifications (for lazy loading)
  void _initializeSampleDataSilently() {
    if (_isDataInitialized) return;

    // Sample child user
    final child = User(
      id: '1',
      name: 'Budi',
      type: UserType.child,
      ageTier: AgeTier.tingkat1,
      age: 8,
      parentId: 'parent1',
      createdAt: DateTime.now(),
    );

    _currentUser = child;

    // Sample savings goal
    final goal = SavingsGoal(
      id: '1',
      userId: '1',
      name: 'Robot Toy',
      description: 'Robot mainan yang keren!',
      targetAmount: 150000,
      currentAmount: 50000,
      iconName: 'toy',
      createdAt: DateTime.now(),
      targetDate: DateTime.now().add(const Duration(days: 30)),
    );

    _savingsGoals.add(goal);

    // Sample mission
    final mission = Mission(
      id: '1',
      userId: '1',
      parentId: 'parent1',
      title: 'Bersihkan Kamar',
      description: 'Rapikan dan bersihkan kamar tidur',
      reward: 10000,
      type: MissionType.daily,
      createdAt: DateTime.now(),
      deadline: DateTime.now().add(const Duration(hours: 24)),
      iconName: 'cleaning',
    );

    _missions.add(mission);

    // Sample transactions
    final transactions = [
      Transaction(
        id: '1',
        userId: '1',
        type: TransactionType.allowance,
        amount: 20000,
        description: 'Uang saku mingguan',
        status: TransactionStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Transaction(
        id: '2',
        userId: '1',
        type: TransactionType.mission_reward,
        amount: 10000,
        description: 'Reward: Cuci piring',
        status: TransactionStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    _transactions.addAll(transactions);

    _isDataInitialized = true;
  }
}
