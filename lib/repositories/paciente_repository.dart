import 'package:postgres/postgres.dart';
import '../models/paciente.dart';
import '../services/db_service.dart';

class PacienteRepository {
  final DBService _db = DBService();

  // READ - Obtener todos
  Future<List<Paciente>> getAll() async {
    final conn = await _db.connection;
    final results = await conn.mappedResultsQuery(
      'SELECT * FROM pacientes ORDER BY id',
    );
    return results
        .map((r) => Paciente.fromMap(r['pacientes']!))
        .toList();
  }

  // CREATE - Insertar
  Future<void> insert(Paciente paciente) async {
    final conn = await _db.connection;
    await conn.query(
      'INSERT INTO pacientes (nombre, dni, edad, telefono) VALUES (@n, @d, @e, @t)',
      substitutionValues: {
        'n': paciente.nombre,
        'd': paciente.dni,
        'e': paciente.edad,
        't': paciente.telefono,
      },
    );
  }

  // UPDATE
  Future<void> update(Paciente paciente) async {
    final conn = await _db.connection;
    await conn.query(
      'UPDATE pacientes SET nombre=@n, edad=@e, telefono=@t WHERE id=@id',
      substitutionValues: {
        'n': paciente.nombre,
        'e': paciente.edad,
        't': paciente.telefono,
        'id': paciente.id,
      },
    );
  }

  // DELETE
  Future<void> delete(int id) async {
    final conn = await _db.connection;
    await conn.query(
      'DELETE FROM pacientes WHERE id=@id',
      substitutionValues: {'id': id},
    );
  }

  // BONUS: Búsqueda por DNI con LIKE
  Future<List<Paciente>> searchByDni(String query) async {
    final conn = await _db.connection;
    final results = await conn.mappedResultsQuery(
      "SELECT * FROM pacientes WHERE dni LIKE @q",
      substitutionValues: {'q': '%$query%'},
    );
    return results
        .map((r) => Paciente.fromMap(r['pacientes']!))
        .toList();
  }
}