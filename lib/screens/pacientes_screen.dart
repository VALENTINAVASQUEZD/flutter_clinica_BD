import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../repositories/paciente_repository.dart';
import 'agregar_paciente_screen.dart';

class PacientesScreen extends StatefulWidget {
  const PacientesScreen({super.key});

  @override
  State<PacientesScreen> createState() => _PacientesScreenState();
}

class _PacientesScreenState extends State<PacientesScreen> {
  final _repo = PacienteRepository();
  final _searchController = TextEditingController();
  late Future<List<Paciente>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _repo.getAll();
  }

  void _refresh() {
    setState(() => _futuro = _repo.getAll());
  }

  void _search(String query) {
    setState(() {
      _futuro = query.isEmpty
          ? _repo.getAll()
          : _repo.searchByDni(query);
    });
  }

  void _showSnack(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Buscar por DNI...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _search,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Paciente>>(
        future: _futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final pacientes = snapshot.data ?? [];
          if (pacientes.isEmpty) {
            return const Center(child: Text('No hay pacientes registrados'));
          }
          return ListView.builder(
            itemCount: pacientes.length,
            itemBuilder: (context, index) {
              final p = pacientes[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(p.nombre),
                subtitle: Text('DNI: ${p.dni} | Tel: ${p.telefono}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    try {
                      await _repo.delete(p.id!);
                      _showSnack('Paciente eliminado');
                      _refresh();
                    } catch (e) {
                      _showSnack('Error al eliminar', error: true);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AgregarPacienteScreen(repo: _repo),
            ),
          );
          _refresh();
        },
      ),
    );
  }
}