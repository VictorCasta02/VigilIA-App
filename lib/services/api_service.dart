import 'package:dio/dio.dart';
import '../constants.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: Constants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'ngrok-skip-browser-warning': 'true'},
  ));

  // Enviar coordenada GPS
  static Future<Map<String, dynamic>> enviarCoordenada({
    required String hijoId,
    required double lat,
    required double lng,
    String? trayectoriaId,
  }) async {
    try {
      final response = await _dio.post('/gps/coordenada', data: {
        'hijo_id': hijoId,
        'latitud': lat,
        'longitud': lng,
        'timestamp': DateTime.now().toIso8601String(),
        'trayectoria_id': trayectoriaId,
      });
      return response.data;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Obtener alertas del hijo
static Future<List<dynamic>> obtenerAlertas(String hijoId) async {
  try {
    final response = await _dio.get(
      '/alerts/$hijoId',
      options: Options(headers: {'ngrok-skip-browser-warning': 'true'}),
    );
    print('Alertas response: ${response.data}');
    return response.data['alertas'] ?? [];
  } catch (e) {
    print('Error alertas: $e');
    return [];
  }
}

  // Obtener trayectorias
  static Future<List<dynamic>> obtenerTrayectorias(String hijoId) async {
    try {
      final response = await _dio.get('/gps/trayectorias/$hijoId');
      return response.data['trayectorias'] ?? [];
    } catch (e) {
      return [];
    }
  }

  // Obtener zonas de riesgo
  static Future<List<dynamic>> obtenerZonas(String padreId) async {
    try {
      final response = await _dio.get('/zones/$padreId');
      return response.data['zonas'] ?? [];
    } catch (e) {
      return [];
    }
  }

  // Cerrar trayectoria
  static Future<Map<String, dynamic>> cerrarTrayectoria(String trayectoriaId) async {
    try {
      final response = await _dio.patch('/gps/trayectoria/$trayectoriaId/cerrar');
      return response.data;
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}