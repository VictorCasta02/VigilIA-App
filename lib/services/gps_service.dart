import 'package:geolocator/geolocator.dart';
import 'api_service.dart';

class GpsService {
  static String? _trayectoriaId;
  static bool _activo = false;

  static Future<bool> solicitarPermisos() async {
    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }
    return permiso == LocationPermission.always ||
           permiso == LocationPermission.whileInUse;
  }

  static void iniciarTracking(String hijoId) {
    if (_activo) return;
    _activo = true;
    _trayectoriaId = null;

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // enviar cada 10 metros de movimiento
      ),
    ).listen((Position pos) async {
      final resultado = await ApiService.enviarCoordenada(
        hijoId: hijoId,
        lat: pos.latitude,
        lng: pos.longitude,
        trayectoriaId: _trayectoriaId,
      );
      // Guardar trayectoria_id del primer punto
      if (_trayectoriaId == null && resultado['trayectoria_id'] != null) {
        _trayectoriaId = resultado['trayectoria_id'];
      }
    });
  }

  static Future<void> detenerTracking() async {
    _activo = false;
    if (_trayectoriaId != null) {
      await ApiService.cerrarTrayectoria(_trayectoriaId!);
      _trayectoriaId = null;
    }
  }

  static bool get activo => _activo;
}
