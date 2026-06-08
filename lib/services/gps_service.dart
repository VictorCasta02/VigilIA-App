import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'api_service.dart';

class GpsService {
  static String? _trayectoriaId;
  static bool _activo = false;
  static Timer? _timer;
  static Position? _ultimaPosicion;

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

    // Escuchar cambios de posición
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position pos) {
      _ultimaPosicion = pos;
    });

    // Timer que envía la posición cada 10 segundos
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!_activo) {
        timer.cancel();
        return;
      }

      // Si no hay posición del stream, obtenerla directamente
      Position pos = _ultimaPosicion ?? await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final resultado = await ApiService.enviarCoordenada(
        hijoId: hijoId,
        lat: pos.latitude,
        lng: pos.longitude,
        trayectoriaId: _trayectoriaId,
      );

      if (_trayectoriaId == null && resultado['trayectoria_id'] != null) {
        _trayectoriaId = resultado['trayectoria_id'];
      }

      print('GPS enviado: ${pos.latitude}, ${pos.longitude}');
    });
  }

  static Future<void> detenerTracking() async {
    _activo = false;
    _timer?.cancel();
    _timer = null;
    if (_trayectoriaId != null) {
      await ApiService.cerrarTrayectoria(_trayectoriaId!);
      _trayectoriaId = null;
    }
  }

  static bool get activo => _activo;
}