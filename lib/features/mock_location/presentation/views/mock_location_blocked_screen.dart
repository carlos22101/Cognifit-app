import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../viewmodels/mock_location_viewmodel.dart';

class MockLocationBlockedScreen extends StatefulWidget {
  const MockLocationBlockedScreen({super.key});

  @override
  State<MockLocationBlockedScreen> createState() =>
      _MockLocationBlockedScreenState();
}

class _MockLocationBlockedScreenState extends State<MockLocationBlockedScreen> {
  bool _isChecking = false;

  Future<void> _retryCheck() async {
    setState(() => _isChecking = true);

    final status = await MockLocationViewModel.checkMockLocation();

    if (!mounted) return;

    if (status.isMocked) {
      setState(() => _isChecking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aún se detecta GPS falso. Desactívalo e intenta de nuevo.'),
          backgroundColor: Color(0xFFEF5350),
        ),
      );
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF5F7FF),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECEB),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.location_off_rounded,
                      size: 50,
                      color: Color(0xFFEF5350),
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'GPS Falso Detectado',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Se ha detectado una aplicación de ubicación falsa '
                    '(Fake GPS) en tu dispositivo.\n\n'
                    'Por seguridad, CogniFit no puede ejecutarse mientras '
                    'una app de GPS falso esté activa.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF4A4A68),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFFFA726).withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: Color(0xFFFFA726), size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Pasos para solucionar:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '1. Desactiva o desinstala la app de GPS falso\n'
                          '2. Desactiva "Ubicaciones simuladas" en\n'
                          '   Opciones de desarrollador\n'
                          '3. Presiona "Reintentar" abajo',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF4A4A68),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isChecking ? null : _retryCheck,
                      icon: _isChecking
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.refresh_rounded),
                      label: Text(_isChecking ? 'Verificando...' : 'Reintentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A73E8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: const Text(
                      'Salir de la aplicación',
                      style: TextStyle(
                        color: Color(0xFF8A8AA8),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
