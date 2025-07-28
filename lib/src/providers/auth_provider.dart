import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../models/auth_user.dart';
import '../core/helpers.dart';

class AuthProvider extends ChangeNotifier {
  AuthUser? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Storage keys
  static const String _usersKey = 'auth_users';
  static const String _currentUserKey = 'current_user';

  AuthUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  // Initialize auth provider
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _loadCurrentUser();
    } catch (e) {
      _setError('Failed to initialize auth: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load current user from storage
  Future<void> _loadCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_currentUserKey);

      if (userJson != null) {
        final userData = json.decode(userJson);
        _currentUser = AuthUser.fromJson(userData);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading current user: $e');
    }
  }

  // Save current user to storage
  Future<void> _saveCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_currentUser != null) {
        await prefs.setString(
            _currentUserKey, json.encode(_currentUser!.toJson()));
      } else {
        await prefs.remove(_currentUserKey);
      }
    } catch (e) {
      debugPrint('Error saving current user: $e');
    }
  }

  // Get all users from storage
  Future<List<AuthUser>> _getAllUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);

      if (usersJson != null) {
        final List<dynamic> usersList = json.decode(usersJson);
        return usersList
            .map((userData) => AuthUser.fromJson(userData))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error loading users: $e');
      return [];
    }
  }

  // Save all users to storage
  Future<void> _saveAllUsers(List<AuthUser> users) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson =
          json.encode(users.map((user) => user.toJson()).toList());
      await prefs.setString(_usersKey, usersJson);
    } catch (e) {
      debugPrint('Error saving users: $e');
    }
  }

  // Generate random child code
  String _generateChildCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  // Register parent
  Future<bool> registerParent({
    required String email,
    required String password,
    required String name,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Validate input
      if (email.isEmpty || !Helpers.isValidEmail(email)) {
        _setError('Email tidak valid');
        return false;
      }

      if (password.isEmpty || password.length < 6) {
        _setError('Password minimal 6 karakter');
        return false;
      }

      if (name.isEmpty) {
        _setError('Nama tidak boleh kosong');
        return false;
      }

      // Check if email already exists
      final existingUsers = await _getAllUsers();
      if (existingUsers
          .any((user) => user.email.toLowerCase() == email.toLowerCase())) {
        _setError('Email sudah terdaftar');
        return false;
      }

      // Create new parent user
      final newUser = AuthUser(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email.toLowerCase(),
        password: password, // In real app, this should be hashed
        name: name,
        role: UserRole.parent,
        childCode: _generateChildCode(),
        createdAt: DateTime.now(),
      );

      // Save user
      existingUsers.add(newUser);
      await _saveAllUsers(existingUsers);

      // Auto login
      _currentUser = newUser;
      await _saveCurrentUser();
      notifyListeners();

      return true;
    } catch (e) {
      _setError('Gagal mendaftar: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Login parent
  Future<bool> loginParent({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Validate input
      if (email.isEmpty || password.isEmpty) {
        _setError('Email dan password tidak boleh kosong');
        return false;
      }

      // Find user
      final users = await _getAllUsers();
      final user = users.firstWhere(
        (user) =>
            user.email.toLowerCase() == email.toLowerCase() &&
            user.role == UserRole.parent &&
            user.password == password,
        orElse: () => throw Exception('User not found'),
      );

      // Update last login
      final updatedUser = user.copyWith(lastLoginAt: DateTime.now());
      final userIndex = users.indexWhere((u) => u.id == user.id);
      users[userIndex] = updatedUser;
      await _saveAllUsers(users);

      // Set current user
      _currentUser = updatedUser;
      await _saveCurrentUser();
      notifyListeners();

      return true;
    } catch (e) {
      _setError('Email atau password salah');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Login child with code
  Future<bool> loginChild({
    required String childCode,
    required String childName,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Validate input
      if (childCode.isEmpty || childName.isEmpty) {
        _setError('Kode dan nama tidak boleh kosong');
        return false;
      }

      // Find parent with matching child code
      final users = await _getAllUsers();
      final parent = users.firstWhere(
        (user) =>
            user.role == UserRole.parent &&
            user.childCode?.toUpperCase() == childCode.toUpperCase(),
        orElse: () => throw Exception('Parent not found'),
      );

      // Check if child already exists
      final existingChild = users.firstWhere(
        (user) =>
            user.role == UserRole.child &&
            user.parentId == parent.id &&
            user.name.toLowerCase() == childName.toLowerCase(),
        orElse: () => AuthUser(
          id: '',
          email: '',
          name: '',
          role: UserRole.child,
          createdAt: DateTime.now(),
        ),
      );

      AuthUser childUser;
      if (existingChild.id.isEmpty) {
        // Create new child user
        childUser = AuthUser(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          email:
              '${parent.email}_child_${DateTime.now().millisecondsSinceEpoch}',
          name: childName,
          role: UserRole.child,
          parentId: parent.id,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
        users.add(childUser);
      } else {
        // Update existing child
        childUser = existingChild.copyWith(lastLoginAt: DateTime.now());
        final childIndex = users.indexWhere((u) => u.id == existingChild.id);
        users[childIndex] = childUser;
      }

      await _saveAllUsers(users);

      // Set current user
      _currentUser = childUser;
      await _saveCurrentUser();
      notifyListeners();

      return true;
    } catch (e) {
      _setError('Kode tidak valid atau tidak ditemukan');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get parent for current child
  Future<AuthUser?> getParentForChild() async {
    if (_currentUser?.role != UserRole.child ||
        _currentUser?.parentId == null) {
      return null;
    }

    try {
      final users = await _getAllUsers();
      return users.firstWhere(
        (user) => user.id == _currentUser!.parentId,
        orElse: () => throw Exception('Parent not found'),
      );
    } catch (e) {
      return null;
    }
  }

  // Get children for current parent
  Future<List<AuthUser>> getChildrenForParent() async {
    if (_currentUser?.role != UserRole.parent) {
      return [];
    }

    try {
      final users = await _getAllUsers();
      return users
          .where(
            (user) =>
                user.role == UserRole.child &&
                user.parentId == _currentUser!.id,
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
    await _saveCurrentUser();
    notifyListeners();
  }

  // Helper methods
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
    notifyListeners();
  }
}
