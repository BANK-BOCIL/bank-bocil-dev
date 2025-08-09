// lib/src/providers/app_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../models/user.dart';
import '../models/transaction.dart' as local_transaction;
import '../models/savings_goal.dart';
import '../models/mission.dart';
import '../models/budget.dart';
import '../core/constants.dart';

class AppProvider extends ChangeNotifier {
  final firestore.FirebaseFirestore _firestore =
      firestore.FirebaseFirestore.instance;

  // --- STATE VARIABLES ---
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isNotificationEnabled = true;
  ThemeColor _currentTheme = ThemeColor.pink;

  // BARU: State untuk mengelola anak yang sedang dilihat oleh orang tua
  User? _selectedChild;

  // Deklarasi list data
  List<User> _children = [];
  List<local_transaction.Transaction> _transactions = [];
  List<SavingsGoal> _savingsGoals = [];
  List<Mission> _missions = [];
  List<Budget> _budgets = [];

  // --- GETTERS ---
  User? get currentUser => _currentUser;
  User? get selectedChild => _selectedChild; // Getter untuk anak yang dipilih
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isNotificationEnabled => _isNotificationEnabled;
  ThemeColor get currentTheme => _currentTheme;

  // Getter data, sekarang lebih dinamis
  List<User> get children => _children;
  List<local_transaction.Transaction> get transactions => _transactions;
  List<SavingsGoal> get savingsGoals => _savingsGoals;
  List<Mission> get missions => _missions;
  List<Budget> get budgets => _budgets;

  // --- PUBLIC METHODS ---

  // PERBAIKAN: fetchInitialData dipanggil setelah login berhasil.
  // Logikanya sekarang bercabang tergantung tipe user.
  Future<void> fetchInitialData(User user) async {
    _setLoading(true);
    _clearError();
    _clearAllData(); // Bersihkan data lama sebelum fetch
    _currentUser = user;

    try {
      if (_currentUser!.type == UserType.parent) {
        // Jika orang tua, hanya fetch daftar anaknya.
        // Data spesifik (misi, dll) akan di-fetch saat anak dipilih.
        await _fetchChildren(_currentUser!.id);
      } else {
        // Jika anak, langsung fetch semua data miliknya.
        await _fetchDataForUser(_currentUser!.id);
      }
    } catch (e) {
      _setError('Gagal memuat data awal: $e');
    } finally {
      _setLoading(false);
    }
  }

  // BARU: Metode untuk memilih anak dan memuat datanya (dipanggil dari UI).
  Future<void> selectChild(User child) async {
    if (_currentUser?.type != UserType.parent) return;

    _selectedChild = child;
    notifyListeners(); // Update UI untuk menunjukkan anak yang dipilih
    await _fetchDataForUser(child.id);
  }

  // BARU: Metode untuk membersihkan data anak yang dipilih.
  void clearSelectedChild() {
    _selectedChild = null;
    _clearAllData(clearChildren: false); // Jangan hapus daftar anak
    notifyListeners();
  }

  // --- METHODS UNTUK INTERAKSI DENGAN FIRESTORE ---

  // PERBAIKAN: Logika CRUD sekarang lebih efisien.
  // Hanya me-refresh data yang relevan, bukan semuanya.
  // Asumsi: Objek 'mission' memiliki properti 'userId'.
  Future<void> addMission(Mission mission) async {
    _setLoading(true);
    _clearError();
    try {
      await _firestore.collection('missions').add(mission.toFirestore());
      // Refresh hanya data misi untuk user yang bersangkutan.
      await _fetchMissions(mission.userId);
    } catch (e) {
      _setError('Gagal menambahkan misi: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateMission(Mission updatedMission) async {
    _setLoading(true);
    _clearError();
    try {
      if (updatedMission.id != null) {
        await _firestore
            .collection('missions')
            .doc(updatedMission.id)
            .update(updatedMission.toFirestore());
        // Refresh hanya data misi untuk user yang bersangkutan.
        await _fetchMissions(updatedMission.userId);
      }
    } catch (e) {
      _setError('Gagal memperbarui misi: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Metode lain (addTransaction, updateTransaction, dsb.) harus mengikuti pola yang sama.

  // --- PRIVATE FETCH METHODS ---

  // BARU: Metode terpusat untuk fetch semua data milik satu user (parent/child).
  Future<void> _fetchDataForUser(String userId) async {
    _setLoading(true);
    try {
      await _fetchMissions(userId);
      await _fetchTransactions(userId);
      await _fetchSavingsGoals(userId);
      // Tambahkan fetch data lain di sini jika ada.
    } catch (e) {
      _setError('Gagal memuat data untuk user $userId: $e');
      rethrow; // Lempar kembali agar bisa ditangkap oleh pemanggil
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _fetchChildren(String parentId) async {
    final childrenSnapshot = await _firestore
        .collection('users')
        .where('parentId', isEqualTo: parentId)
        .get();
    _children = childrenSnapshot.docs
        .map((doc) => User.fromFirestore(doc.data()))
        .toList();
    notifyListeners();
  }

  Future<void> _fetchMissions(String userId) async {
    final missionsSnapshot = await _firestore
        .collection('missions')
        .where('userId', isEqualTo: userId)
        .get();
    _missions =
        missionsSnapshot.docs.map((doc) => Mission.fromFirestore(doc)).toList();
    notifyListeners();
  }

  Future<void> _fetchTransactions(String userId) async {
    final transactionsSnapshot = await _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .get();
    _transactions = transactionsSnapshot.docs
        .map((doc) => local_transaction.Transaction.fromFirestore(doc))
        .toList();
    notifyListeners();
  }

  Future<void> _fetchSavingsGoals(String userId) async {
    final goalsSnapshot = await _firestore
        .collection('savings_goals')
        .where('userId', isEqualTo: userId)
        .get();
    _savingsGoals = goalsSnapshot.docs
        .map((doc) => SavingsGoal.fromFirestore(doc))
        .toList();
    notifyListeners();
  }

  // --- UTILITY METHODS ---

  void _clearAllData({bool clearChildren = true}) {
    if (clearChildren) _children = [];
    _transactions = [];
    _savingsGoals = [];
    _missions = [];
    _budgets = [];
    _selectedChild = null;
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
    notifyListeners();
  }
}
