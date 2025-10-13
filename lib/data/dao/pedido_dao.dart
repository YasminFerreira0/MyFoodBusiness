import 'package:app/data/database_helper.dart';
import 'package:app/models/pedido.dart';
import 'package:sqflite/sqflite.dart';

class PedidoDAO {
  Future<int> insert(Pedido pedido) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(
      'pedido',
      pedido.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update(Pedido pedido) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.update(
      'pedido',
      {
        "status": pedido.status,
        "observacoes": pedido.observacoes
      },
      where: "id = ?",
      whereArgs: [pedido.id],
    );
  }

  Future<int> delete(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(
      'pedido', 
      where: "id = ?", 
      whereArgs: [id]
    );
  }

  Future<List<Pedido>> list() async {
    final Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> pedidos = await db.query('pedido');
    return List.generate(pedidos.length, (i) {
      return Pedido.fromMap(pedidos[i]);
    });
  }
} 