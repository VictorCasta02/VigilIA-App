import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../constants.dart';

class AlertasScreen extends StatefulWidget {
  const AlertasScreen({super.key});

  @override
  State<AlertasScreen> createState() => _AlertasScreenState();
}

class _AlertasScreenState extends State<AlertasScreen> {
  List<dynamic> _alertas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final alertas = await ApiService.obtenerAlertas(Constants.hijoId);
    setState(() { _alertas = alertas; _cargando = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de alertas'),
        backgroundColor: const Color(0xFF1A5276),
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _alertas.isEmpty
              ? const Center(child: Text('Sin alertas registradas'))
              : ListView.builder(
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
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: color.withOpacity(0.15),
                          child: Icon(Icons.warning_rounded, color: color),
                        ),
                        title: Text(a['descripcion'] ?? ''),
                        subtitle: Text('${a['tipo']} • $nivel • ${a['created_at']}'),
                      ),
                    );
                  },
                ),
    );
  }
}