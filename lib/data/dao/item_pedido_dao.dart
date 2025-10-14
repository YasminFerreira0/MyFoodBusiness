import 'package:app/data/database_helper.dart';
import 'package:app/models/item_pedido.dart';
import 'package:sqflite/sqflite.dart';

class ItemPedidoDAO {
   Future<int> insert(ItemPedido itemPedido) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(
      'item_pedido',
      itemPedido.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update(ItemPedido itemPedido) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.update(
      'item_pedido',
      itemPedido.toMap(),
      where: "id = ?",
      whereArgs: [itemPedido.id],
    );
  }

  Future<int> delete(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(
      'item_pedido', 
      where: "id = ?", 
      whereArgs: [id]
    );
  }

  Future<List<ItemPedido>> getItensByPedidoId(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> itemPedidos = await db.query( 'item_pedido', where: 'pedidoId = ?', whereArgs: [id]);
    return List.generate(itemPedidos.length, (i) {
      return ItemPedido.fromMap(itemPedidos[i]);
    });
  }

  Future<List<ItemPedido>> list() async {
    final Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> itemPedidos = await db.query('item_pedido');
    return List.generate(itemPedidos.length, (i) {
      return ItemPedido.fromMap(itemPedidos[i]);
    });
  }
}  
