import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'storage_service.dart';
import 'firebase_service.dart';

class SyncService {
  final StorageService _storageService;
  final FirebaseService? _firebaseService;
  final bool firebaseEnabled;
  final Connectivity _connectivity = Connectivity();

  StreamController<bool> syncStatusController = StreamController<bool>.broadcast();
  StreamController<String> syncMessageController = StreamController<String>.broadcast();

  bool _isSyncing = false;

  SyncService(
      this._storageService,
      this._firebaseService, {
        this.firebaseEnabled = false,
      }) {
    _listenToConnectivity();
    syncMessageController.add('📱 Ready - Data saved locally');
  }

  void _listenToConnectivity() {
    _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none && firebaseEnabled) {
        syncUnsyncedData();
      }
    });
  }

  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> syncUnsyncedData() async {
    if (_isSyncing) return;

    if (!firebaseEnabled || _firebaseService == null) {
      syncMessageController.add('✅ Data saved successfully');
      return;
    }

    final online = await isOnline();
    if (!online) {
      syncMessageController.add('📱 Saved locally');
      return;
    }

    _isSyncing = true;
    syncStatusController.add(true);
    syncMessageController.add('🔄 Syncing...');

    try {
      final unsyncedProgress = _storageService.getUnsyncedProgress();

      if (unsyncedProgress.isEmpty) {
        syncMessageController.add('✅ All data synced');
        syncStatusController.add(false);
        _isSyncing = false;
        return;
      }

      await _firebaseService!.syncMultipleProgress(unsyncedProgress);

      for (var progress in unsyncedProgress) {
        await _storageService.markProgressAsSynced(progress.id);
      }

      syncMessageController.add('✅ Synced ${unsyncedProgress.length} items');
      syncStatusController.add(false);
    } catch (e) {
      syncMessageController.add('📱 Saved locally');
      syncStatusController.add(false);
    }

    _isSyncing = false;
  }

  void dispose() {
    syncStatusController.close();
    syncMessageController.close();
  }
}