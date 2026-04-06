import 'package:postgres/postgres.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  PostgreSQLConnection? _connection;

  Future<PostgreSQLConnection> get connection async {
    if (_connection == null || _connection!.isClosed) {
      _connection = PostgreSQLConnection(
        'localhost',   
        5432,          
        'clinica',     
        username: 'postgres',
        password: '0000',
      );
      await _connection!.open();
    }
    return _connection!;
  }
}