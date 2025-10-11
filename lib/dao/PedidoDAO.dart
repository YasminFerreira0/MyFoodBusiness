import 'package:app/dao/DatabaseHelper.dart';
import 'package:app/models/Pedido.dart';
import 'package:sqflite/sqflite.dart';

class PedidoDAO {
  List<Map<String, dynamic>> _pedidos = [];

  Future<void> insert(Pedido pedido) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert(
      'pedido',
      pedido.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertSQL(Pedido pedido) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.rawInsert(
      'INSERT INTO pedido(clienteId, dataHora, status, valorTotal, metodoPagamento, observacoes) VALUES(?, ?, ?, ?, ?, ?)', 
      [pedido.clienteId, pedido.dataHora, pedido.status, pedido.valorTotal, pedido.metodoPagamento, pedido.observacoes]
    );
  }

  Future<void> update(Pedido pedido) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.update(
      'pedido',
      {
        "status": pedido.status,
        "observacoes": pedido.observacoes
      },
      where: "id = ?",
      whereArgs: [pedido.id],
    );
  }

  Future<void> updateSQL(Pedido pedido) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.rawUpdate('UPDATE pedido SET status = ?, observacoes = ? WHERE id = ?', [
      pedido.status,
      pedido.observacoes
    ]);
  }

  Future<void> delete(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.delete(
      'pedido', 
      where: "id = ?", 
      whereArgs: [id]
    );
  }

  Future<void> deleteSQL(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.rawDelete('DELETE FROM pedido WHERE id = ?', [id]);
  }

  Future<List<Pedido>> list() async {
    final Database db = await DatabaseHelper.instance.database;
    _pedidos = await db.query('pedido');
    return List.generate(_pedidos.length, (i) {
      return Pedido.fromMap(_pedidos[i]);
    });
  }

  List get pedidos {
    list();
    return _pedidos;
  }
} 