import 'package:app/dao/DatabaseHelper.dart';
import 'package:app/models/Cliente.dart';
import 'package:sqflite/sqflite.dart';

class ClienteDAO {
  List<Map<String, dynamic>> _clientes = [];

  Future<void> insert(Cliente cliente) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert(
      'cliente',
      cliente.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertSQL(Cliente cliente) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.rawInsert(
      'INSERT INTO cliente(nome, telefone, email, cpf) VALUES(?, ?, ?, ?)', 
      [cliente.nome, cliente.telefone, cliente.email, cliente.cpf]
    );
  }

  Future<void> update(Cliente cliente) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.update(
      'cliente',
      cliente.toMap(),
      where: "id = ?",
      whereArgs: [cliente.id],
    );
  }

  Future<void> updateSQL(Cliente cliente) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.rawUpdate('UPDATE cliente SET nome = ?, telefone = ?, email = ?, cpf = ? WHERE id = ?', [
      cliente.nome,
      cliente.telefone,
      cliente.email,
      cliente.cpf,
      cliente.id,
    ]);
  }

  Future<void> delete(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.delete(
      'cliente', 
      where: "id = ?", 
      whereArgs: [id]
    );
  }

  Future<void> deleteSQL(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.rawDelete('DELETE FROM cliente WHERE id = ?', [id]);
  }

  Future<List<Cliente>> list() async {
    final Database db = await DatabaseHelper.instance.database;
    _clientes = await db.query('cliente');
    return List.generate(_clientes.length, (i) {
      return Cliente.fromMap(_clientes[i]);
    });
  }

  List get clientes {
    list();
    return _clientes;
  }
}