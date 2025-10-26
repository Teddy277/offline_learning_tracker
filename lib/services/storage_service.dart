import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/progress.dart';

class StorageService {
  static const String userBoxName = 'users';
  static const String progressBoxName = 'progress';

  Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ProgressAdapter());
    }

    // Open Boxes
    await Hive.openBox<User>(userBoxName);
    await Hive.openBox<Progress>(progressBoxName);
  }

  // User Methods
  Future<void> saveUser(User user) async {
    final box = Hive.box<User>(userBoxName);
    await box.put(user.id, user);
  }

  List<User> getAllUsers() {
    final box = Hive.box<User>(userBoxName);
    return box.values.toList();
  }

  User? getUser(String id) {
    final box = Hive.box<User>(userBoxName);
    return box.get(id);
  }

  Future<void> deleteUser(String userId) async {
    final box = Hive.box<User>(userBoxName);
    await box.delete(userId);
  }

  // Progress Methods
  Future<void> saveProgress(Progress progress) async {
    final box = Hive.box<Progress>(progressBoxName);
    await box.put(progress.id, progress);
  }

  List<Progress> getAllProgress() {
    final box = Hive.box<Progress>(progressBoxName);
    return box.values.toList();
  }

  List<Progress> getUserProgress(String userId) {
    final box = Hive.box<Progress>(progressBoxName);
    return box.values.where((p) => p.userId == userId).toList();
  }

  List<Progress> getUnsyncedProgress() {
    final box = Hive.box<Progress>(progressBoxName);
    return box.values.where((p) => !p.isSynced).toList();
  }

  Future<void> markProgressAsSynced(String progressId) async {
    final box = Hive.box<Progress>(progressBoxName);
    final progress = box.get(progressId);
    if (progress != null) {
      progress.isSynced = true;
      await progress.save();
    }
  }

  Future<void> deleteUserProgress(String userId) async {
    final box = Hive.box<Progress>(progressBoxName);
    final userProgress = box.values.where((p) => p.userId == userId).toList();

    for (var progress in userProgress) {
      await box.delete(progress.id);
    }
  }

  Future<void> clearAll() async {
    await Hive.box<User>(userBoxName).clear();
    await Hive.box<Progress>(progressBoxName).clear();
  }
}