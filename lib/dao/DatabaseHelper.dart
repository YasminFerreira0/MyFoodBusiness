import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  Database? _database;

  DatabaseHelper._internal();

  static DatabaseHelper get instance {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }
  
  Future<Database> initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "myfoodbusiness.db");

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute(clienteTableDDL);
        await db.execute(pedidoTableDDL);
      }
    );
  }

  static const String clienteTableDDL = '''
    CREATE TABLE cliente(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      telefone TEXT NOT NULL,
      email TEXT NOT NULL,
      cpf TEXT NOT NULL
    );
  ''';
  
  static const String pedidoTableDDL = '''
    CREATE TABLE pedido(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      clienteId INTEGER NOT NULL,
      dataHora TEXT NOT NULL,
      status TEXT NOT NULL,
      valorTotal REAL NOT NULL,
      metodoPagamento TEXT NOT NULL,
      observacoes TEXT,
      FOREIGN KEY (clienteId) REFERENCES cliente(id) ON DELETE CASCADE
    )
  ''';
}