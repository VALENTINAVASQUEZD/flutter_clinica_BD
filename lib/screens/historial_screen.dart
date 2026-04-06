import 'package:flutter/material.dart';
import '../models/historial_clinico.dart';
import '../services/mongo_service.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final _mongo = MongoService();
  final _idCtrl = TextEditingController();
  HistorialClinico? _historial;
  bool _loading = false;
  String? _error;

  Future<void> _buscar() async {
    setState(() { _loading = true; _error = null; });
    try {
      final doc = await _mongo.findByPacienteId(_idCtrl.text.trim());
      setState(() {
        _historial = doc != null ? HistorialClinico.fromJson(doc) : null;
        if (doc == null) _error = 'No se encontró historial para este ID';
      });
    } catch (e) {
      setState(() => _error = 'Error de conexión: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial Clínico')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _idCtrl,
                    decoration: const InputDecoration(
                      labelText: 'ID del paciente',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _buscar,
                  child: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_historial != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paciente: ${_historial!.nombrePaciente}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    const Text('Timeline de visitas:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _historial!.consultas.length,
                        itemBuilder: (context, i) {
                          final c = _historial!.consultas[i];
                          return ListTile(
                            leading: const Icon(Icons.medical_services),
                            title: Text(c.motivo),
                            subtitle: Text(
                                'Diagnóstico: ${c.diagnostico}\nFecha: ${c.fecha}'),
                            isThreeLine: true,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}