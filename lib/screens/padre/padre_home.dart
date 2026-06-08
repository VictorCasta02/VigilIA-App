import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../services/api_service.dart';
import '../../constants.dart';
import 'alertas_screen.dart';
import 'zonas_screen.dart';

class PadreHome extends StatefulWidget {
  const PadreHome({super.key});

  @override
  State<PadreHome> createState() => _PadreHomeState();
}

class _PadreHomeState extends State<PadreHome> {
  List<dynamic> _alertas = [];
  List<Marker> _marcadores = [];
  final MapController _mapController = MapController();
  int _paginaActual = 0;

  @override
  void initState() {
    super.initState();
    _cargarAlertas();
  }

  Future<void> _cargarAlertas() async {
    final alertas = await ApiService.obtenerAlertas(Constants.hijoId);
    setState(() {
      _alertas = alertas;
      _marcadores = alertas.map((a) {
        final lat = a['latitud'] as double;
        final lng = a['longitud'] as double;
        final nivel = a['nivel'] as String;
        return Marker(
          point: LatLng(lat, lng),
          width: 40, height: 40,
          child: Icon(
            Icons.warning_rounded,
            color: nivel == 'critico'
                ? const Color(0xFFE74C3C)
                : nivel == 'alerta'
                    ? const Color(0xFFF39C12)
                    : const Color(0xFF27AE60),
            size: 36,
          ),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [_buildMapa(), _buildAlertas(), _buildOpciones()];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5276),
        foregroundColor: Colors.white,
        title: const Text('VigilIA — Padre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarAlertas,
          )
        ],
      ),
      body: pages[_paginaActual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaActual,
        selectedItemColor: const Color(0xFF1A5276),
        onTap: (i) => setState(() => _paginaActual = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alertas'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Opciones'),
        ],
      ),
    );
  }

  Widget _buildMapa() {
    return FlutterMap(
      mapController: _mapController,
      options: const MapOptions(
        initialCenter: LatLng(20.6597, -103.3496),
        initialZoom: 13,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.vigilia.app',
        ),
        MarkerLayer(markers: _marcadores),
      ],
    );
  }

  Widget _buildAlertas() {
    if (_alertas.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 80, color: Color(0xFF27AE60)),
            SizedBox(height: 16),
            Text('Sin alertas activas', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _alertas.length,
      itemBuilder: (context, i) {
        final a = _alertas[i];
        final nivel = a['nivel'] as String;
        final color = nivel == 'critico'
            ? const Color(0xFFE74C3C)
            : nivel == 'alerta'
                ? const Color(0xFFF39C12)
                : const Color(0xFF3498DB);
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(Icons.warning_rounded, color: color),
            ),
            title: Text(a['descripcion'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${a['tipo']} • ${nivel.toUpperCase()}'),
            trailing: a['leida'] == false
                ? Container(
                    width: 10, height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE74C3C), shape: BoxShape.circle),
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildOpciones() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.map, color: Color(0xFF1A5276)),
            title: const Text('Gestionar zonas de riesgo'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ZonasScreen())),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history, color: Color(0xFF1A5276)),
            title: const Text('Historial de alertas'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AlertasScreen())),
          ),
        ],
      ),
    );
  }
}