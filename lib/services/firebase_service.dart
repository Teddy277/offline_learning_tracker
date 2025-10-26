import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/progress.dart';
import '../models/user.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sync User
  Future<void> syncUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
      print('✅ User synced: ${user.name}');
    } catch (e) {
      print('❌ Error syncing user: $e');
      rethrow;
    }
  }

  // Sync Progress
  Future<void> syncProgress(Progress progress) async {
    try {
      await _firestore
          .collection('progress')
          .doc(progress.id)
          .set(progress.toJson());
      print('✅ Progress synced: ${progress.id}');
    } catch (e) {
      print('❌ Error syncing progress: $e');
      rethrow;
    }
  }

  // Sync Multiple Progress Items
  Future<void> syncMultipleProgress(List<Progress> progressList) async {
    final batch = _firestore.batch();

    for (var progress in progressList) {
      final docRef = _firestore.collection('progress').doc(progress.id);
      batch.set(docRef, progress.toJson());
    }

    await batch.commit();
    print('✅ Batch synced ${progressList.length} items');
  }
}