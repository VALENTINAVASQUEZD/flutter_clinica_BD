import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../repositories/paciente_repository.dart';

class AgregarPacienteScreen extends StatefulWidget {
  final PacienteRepository repo;
  const AgregarPacienteScreen({super.key, required this.repo});

  @override
  State<AgregarPacienteScreen> createState() => _AgregarPacienteScreenState();
}

class _AgregarPacienteScreenState extends State<AgregarPacienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _dni = TextEditingController();
  final _edad = TextEditingController();
  final _telefono = TextEditingController();

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await widget.repo.insert(Paciente(
        nombre: _nombre.text.trim(),
        dni: _dni.text.trim(),
        edad: int.parse(_edad.text.trim()),
        telefono: _telefono.text.trim(),
      ));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Paciente registrado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Paciente')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombre,
                decoration: const InputDecoration(labelText: 'Nombre completo'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _dni,
                decoration: const InputDecoration(labelText: 'DNI'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _edad,
                decoration: const InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _telefono,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _guardar,
                icon: const Icon(Icons.save),
                label: const Text('Guardar Paciente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}