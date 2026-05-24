import 'package:geolocator/geolocator.dart';
import '../../domain/entities/mock_location_status.dart';

class MockLocationViewModel {
  static Future<MockLocationStatus> checkMockLocation() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return MockLocationStatus.error('Servicio de ubicación desactivado');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return MockLocationStatus.error('Permiso de ubicación denegado');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return MockLocationStatus.error('Permiso de ubicación denegado permanentemente');
    }

    try {
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (position.isMocked) {
        return MockLocationStatus.mocked();
      }
      return MockLocationStatus.safe();
    } catch (e) {
      return MockLocationStatus.error(e.toString());
    }
  }
}
