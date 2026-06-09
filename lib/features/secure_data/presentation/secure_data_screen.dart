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
  }

  Future<void> _load() async {
    final data = await _service.readAll();
    if (mounted) setState(() => _data = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos sensibles (local)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final entry in _data.entries)
            Card(
              child: ListTile(
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
                  onPressed: () async {
                    await _service.wipeSensitiveData();
                    await _load();
                  },
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