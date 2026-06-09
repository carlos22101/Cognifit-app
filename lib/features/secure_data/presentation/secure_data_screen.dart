import 'package:flutter/material.dart';
import '../data/secure_storage_service.dart';

class SecureDataScreen extends StatefulWidget {
  const SecureDataScreen({super.key});

  @override
  State<SecureDataScreen> createState() => _SecureDataScreenState();
}

class _SecureDataScreenState extends State<SecureDataScreen> {
  final _service = SecureStorageService();
  Map<String, String?> _data = {};

  @override
  void initState() {
    super.initState();
    _load();
    // Refresca la pantalla en vivo cuando el wipe (local o por FCM) ocurre.
    SecureStorageService.wipeSignal.addListener(_onWiped);
  }

  @override
  void dispose() {
    SecureStorageService.wipeSignal.removeListener(_onWiped);
    super.dispose();
  }

  Future<void> _load() async {
    final data = await _service.readAll();
    if (mounted) setState(() => _data = data);
  }

  void _onWiped() {
    _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Datos sensibles eliminados remotamente (FCM)'),
          backgroundColor: Color(0xFFEF5350),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos sensibles (local)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Usuario: ${SecureStorageService.currentUserId}',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          for (final entry in _data.entries)
            Card(
              child: ListTile(
                leading: Icon(
                  entry.value == null ? Icons.delete_outline : Icons.lock_outline,
                  color: entry.value == null
                      ? const Color(0xFFEF5350)
                      : const Color(0xFF34C77B),
                ),
                title: Text(entry.key,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(entry.value ?? '— (vacío / borrado) —'),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await _service.seedDummyData();
                    await _load();
                  },
                  child: const Text('Poblar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _service.wipeSensitiveData(),
                  child: const Text('Wipe local (test)'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
