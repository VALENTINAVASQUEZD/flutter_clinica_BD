import 'dart:convert';
import 'package:http/http.dart' as http;

class MongoService {
  static const String _appId = '670530df03708153f35ab9b4';     
  static const String _apiKey = 'al-0uxBAAcCgOAberfPgh2bOqyjuqgU2eD2W8vbhmD55QB';    
  static const String _baseUrl =
      'https://data.mongodb-api.com/app/$_appId/endpoint/data/v1/action';
  static const String _db = 'clinica';
  static const String _collection = 'historiales';

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'api-key': _apiKey,
      };

  // Buscar historial por ID de paciente
  Future<Map<String, dynamic>?> findByPacienteId(String pacienteId) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/findOne'),
      headers: _headers,
      body: jsonEncode({
        'dataSource': 'Cluster0',
        'database': _db,
        'collection': _collection,
        'filter': {'pacienteId': pacienteId},
      }),
    );
    final data = jsonDecode(res.body);
    return data['document'];
  }

  // Agregar consulta con \$push
  Future<void> agregarConsulta(
      String pacienteId, Map<String, dynamic> consulta) async {
    await http.post(
      Uri.parse('$_baseUrl/updateOne'),
      headers: _headers,
      body: jsonEncode({
        'dataSource': 'Cluster0',
        'database': _db,
        'collection': _collection,
        'filter': {'pacienteId': pacienteId},
        'update': {
          '\$push': {'consultas': consulta}
        },
        'upsert': true,
      }),
    );
  }

  // BONUS: Filtrar por rango de fechas (\$gte y \$lte)
  Future<List<dynamic>> findByFechaRango(
      String desde, String hasta) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/find'),
      headers: _headers,
      body: jsonEncode({
        'dataSource': 'Cluster0',
        'database': _db,
        'collection': _collection,
        'filter': {
          'consultas.fecha': {'\$gte': desde, '\$lte': hasta}
        },
      }),
    );
    return jsonDecode(res.body)['documents'] ?? [];
  }
}