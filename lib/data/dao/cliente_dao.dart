import 'package:app/data/database_helper.dart';
import 'package:app/models/cliente.dart';
import 'package:sqflite/sqflite.dart';

class ClienteDAO {
  Future<int> insert(Cliente cliente) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(
      'cliente',
      cliente.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update(Cliente cliente) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.update(
      'cliente',
      cliente.toMap(),
      where: "id = ?",
      whereArgs: [cliente.id],
    );
  }

  Future<int> delete(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(
      'cliente', 
      where: "id = ?", 
      whereArgs: [id]
    );
  }

  Future<List<Cliente>> list() async {
    final Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> clientes = await db.query('cliente');
    return List.generate(clientes.length, (i) {
      return Cliente.fromMap(clientes[i]);
    });
  }
}