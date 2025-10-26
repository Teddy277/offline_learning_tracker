import 'package:flutter/material.dart';
import '../services/sync_service.dart';

class SyncStatusWidget extends StatelessWidget {
  final SyncService syncService;

  const SyncStatusWidget({Key? key, required this.syncService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: syncService.syncMessageController.stream,
      initialData: '📱 Ready',
      builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: _getColor(snapshot.data ?? ''),
          child: Row(
            children: [
              StreamBuilder<bool>(
                stream: syncService.syncStatusController.stream,
                initialData: false,
                builder: (context, syncingSnapshot) {
                  return syncingSnapshot.data == true
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.cloud_done, color: Colors.white, size: 18);
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  snapshot.data ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getColor(String message) {
    if (message.contains('✅')) return const Color(0xFF4CAF50);
    if (message.contains('🔄')) return const Color(0xFFFF9800);
    return const Color(0xFF1976D2);
  }
}