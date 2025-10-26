import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/storage_service.dart';
import 'services/firebase_service.dart';
import 'services/sync_service.dart';
import 'providers/app_provider.dart';
import 'screens/user_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  FirebaseService? firebaseService;
  bool firebaseInitialized = false;

  try {
    await Firebase.initializeApp();
    firebaseService = FirebaseService();
    firebaseInitialized = true;
  } catch (e) {
    firebaseService = null;
  }

  final syncService = SyncService(
    storageService,
    firebaseService,
    firebaseEnabled: firebaseInitialized,
  );

  runApp(MyApp(
    storageService: storageService,
    syncService: syncService,
  ));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  final SyncService syncService;

  const MyApp({
    Key? key,
    required this.storageService,
    required this.syncService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(storageService, syncService),
      child: MaterialApp(
        title: 'Offline Learning Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF2196F3),
          scaffoldBackgroundColor: const Color(0xFFF5F7FA),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1976D2),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: const UserSelectionScreen(),
      ),
    );
  }
}