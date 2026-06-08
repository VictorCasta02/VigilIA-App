import 'package:flutter/material.dart';
import '../../services/gps_service.dart';
import '../../constants.dart';

class HijoHome extends StatefulWidget {
  const HijoHome({super.key});

  @override
  State<HijoHome> createState() => _HijoHomeState();
}

class _HijoHomeState extends State<HijoHome> {
  bool _tracking = false;
  String _estado = 'Inactivo';

  Future<void> _toggleTracking() async {
    if (!_tracking) {
      final permiso = await GpsService.solicitarPermisos();
      if (!permiso) {
        setState(() => _estado = 'Permiso de ubicacion denegado');
        return;
      }
      GpsService.iniciarTracking(Constants.hijoId);
      setState(() { _tracking = true; _estado = 'Enviando ubicacion...'; });
    } else {
      await GpsService.detenerTracking();
      setState(() { _tracking = false; _estado = 'Inactivo'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A5276),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5276),
        foregroundColor: Colors.white,
        title: const Text('VigilIA — Hijo'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Indicador de estado
            Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _tracking
                    ? const Color(0xFF27AE60).withOpacity(0.2)
                    : Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: _tracking ? const Color(0xFF27AE60) : Colors.white38,
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _tracking ? Icons.location_on : Icons.location_off,
                    size: 80,
                    color: _tracking ? const Color(0xFF27AE60) : Colors.white38,
                  ),
                  Text(
                    _tracking ? 'ACTIVO' : 'INACTIVO',
                    style: TextStyle(
                      color: _tracking ? const Color(0xFF27AE60) : Colors.white38,
                      fontWeight: FontWeight.bold, fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(_estado,
              style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _tracking
                    ? const Color(0xFFE74C3C)
                    : const Color(0xFF27AE60),
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: _toggleTracking,
              child: Text(
                _tracking ? 'Detener' : 'Iniciar monitoreo',
                style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}