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
        await db.execute(produtoTableDDL);
        await db.execute(item_pedidoTableDDL);
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
      numeroMesa INTEGER,
      clienteId INTEGER,
      dataHora TEXT NOT NULL,
      status TEXT NOT NULL,
      valorTotal REAL NOT NULL,
      metodoPagamento TEXT NOT NULL,
      observacoes TEXT,
      FOREIGN KEY (clienteId) REFERENCES cliente(id) ON DELETE CASCADE
    )
  ''';
  
  static const String produtoTableDDL = '''
    CREATE TABLE produto(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      preco REAL NOT NULL,
      categoria TEXT NOT NULL,
      descricao TEXT
    )
  ''';
  
  static const String item_pedidoTableDDL = '''
    CREATE TABLE item_pedido(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      pedidoId INTEGER NOT NULL,
      produtoId INTEGER NOT NULL,
      quantidade INTEGER NOT NULL,
      precoUnitario REAL NOT NULL,
      FOREIGN KEY (pedidoId) REFERENCES pedido(id) ON DELETE CASCADE,
      FOREIGN KEY (produtoId) REFERENCES produto(id)
    )
  ''';
}