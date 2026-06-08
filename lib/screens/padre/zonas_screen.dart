import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../constants.dart';

class ZonasScreen extends StatefulWidget {
  const ZonasScreen({super.key});

  @override
  State<ZonasScreen> createState() => _ZonasScreenState();
}

class _ZonasScreenState extends State<ZonasScreen> {
  List<dynamic> _zonas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final zonas = await ApiService.obtenerZonas(Constants.padreId);
    setState(() { _zonas = zonas; _cargando = false; });
  }

  Color _colorNivel(String nivel) {
    switch (nivel) {
      case 'alto': return const Color(0xFFE74C3C);
      case 'medio': return const Color(0xFFF39C12);
      default: return const Color(0xFF27AE60);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zonas de riesgo'),
        backgroundColor: const Color(0xFF1A5276),
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _zonas.isEmpty
              ? const Center(child: Text('Sin zonas registradas'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _zonas.length,
                  itemBuilder: (context, i) {
                    final z = _zonas[i];
                    final nivel = z['nivel_riesgo'] as String;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _colorNivel(nivel).withOpacity(0.15),
                          child: Icon(Icons.location_on,
                            color: _colorNivel(nivel)),
                        ),
                        title: Text(z['nombre'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Nivel: ${nivel.toUpperCase()}'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _colorNivel(nivel).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(nivel,
                            style: TextStyle(
                              color: _colorNivel(nivel),
                              fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}