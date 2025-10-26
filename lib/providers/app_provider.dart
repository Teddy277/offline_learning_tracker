import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/activity.dart';
import '../models/progress.dart';
import '../services/storage_service.dart';
import '../services/sync_service.dart';
import 'package:uuid/uuid.dart';

class AppProvider extends ChangeNotifier {
  final StorageService _storageService;
  final SyncService _syncService;

  User? _currentUser;
  List<User> _users = [];
  List<Activity> _activities = [];
  List<Progress> _userProgress = [];

  User? get currentUser => _currentUser;
  List<User> get users => _users;
  List<Activity> get activities => _activities;
  List<Progress> get userProgress => _userProgress;
  SyncService get syncService => _syncService;

  AppProvider(this._storageService, this._syncService) {
    _init();
  }

  Future<void> _init() async {
    _users = _storageService.getAllUsers();
    _activities = Activity.getSampleActivities();
    notifyListeners();
  }

  Future<void> createUser(String name) async {
    final user = User(
      id: const Uuid().v4(),
      name: name,
      createdAt: DateTime.now(),
    );

    await _storageService.saveUser(user);
    _users = _storageService.getAllUsers();
    _currentUser = user;
    _userProgress = [];
    notifyListeners();
  }

  void selectUser(User user) {
    _currentUser = user;
    _loadUserProgress();
    notifyListeners();
  }

  Future<void> deleteUser(String userId) async {
    // Delete user
    await _storageService.deleteUser(userId);

    // Delete user's progress
    await _storageService.deleteUserProgress(userId);

    // Refresh user list
    _users = _storageService.getAllUsers();

    // Clear current user if deleted
    if (_currentUser?.id == userId) {
      _currentUser = null;
      _userProgress = [];
    }

    notifyListeners();
  }

  void _loadUserProgress() {
    if (_currentUser != null) {
      _userProgress = _storageService.getUserProgress(_currentUser!.id);
    }
  }

  Future<void> submitAnswer(String activityId, int answer, bool isCorrect) async {
    if (_currentUser == null) return;

    final progress = Progress(
      id: const Uuid().v4(),
      userId: _currentUser!.id,
      activityId: activityId,
      answer: answer,
      isCorrect: isCorrect,
      completedAt: DateTime.now(),
      isSynced: false,
    );

    await _storageService.saveProgress(progress);
    _loadUserProgress();
    notifyListeners();

    // Trigger sync
    _syncService.syncUnsyncedData();
  }

  int getCompletedActivitiesCount() {
    return _userProgress.length;
  }

  int getCorrectAnswersCount() {
    return _userProgress.where((p) => p.isCorrect).length;
  }

  bool isActivityCompleted(String activityId) {
    return _userProgress.any((p) => p.activityId == activityId);
  }
}