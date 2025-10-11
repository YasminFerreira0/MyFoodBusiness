import 'package:app/dao/DatabaseHelper.dart';
import 'package:app/models/ItemPedido.dart';
import 'package:sqflite/sqflite.dart';

class ItemPedidoDAO {
  List<Map<String, dynamic>> _itemPedidos = [];

   Future<void> insert(ItemPedido itemPedido) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert(
      'item_pedido',
      itemPedido.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertSQL(ItemPedido itemPedido) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.rawInsert(
      'INSERT INTO item_pedido(pedidoId, produtoId, quantidade, precoUnitario) VALUES(?, ?, ?, ?)', 
      [itemPedido.pedidoId, itemPedido.produtoId, itemPedido.quantidade, itemPedido.precoUnitario]
    );
  }

  Future<void> update(ItemPedido itemPedido) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.update(
      'item_pedido',
      itemPedido.toMap(),
      where: "id = ?",
      whereArgs: [itemPedido.id],
    );
  }

  Future<void> updateSQL(ItemPedido itemPedido) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.rawUpdate('UPDATE item_pedido SET pedidoId = ?, produtoId = ?, quantidade = ?, precoUnitario = ? WHERE id = ?', [
      itemPedido.pedidoId,
      itemPedido.produtoId,
      itemPedido.quantidade,
      itemPedido.precoUnitario
    ]);
  }

  Future<void> delete(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.delete(
      'item_pedido', 
      where: "id = ?", 
      whereArgs: [id]
    );
  }

  Future<void> deleteSQL(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.rawDelete('DELETE FROM item_pedido WHERE id = ?', [id]);
  }

  Future<List<ItemPedido>> list() async {
    final Database db = await DatabaseHelper.instance.database;
    _itemPedidos = await db.query('item_pedido');
    return List.generate(_itemPedidos.length, (i) {
      return ItemPedido.fromMap(_itemPedidos[i]);
    });
  }

  List get itemPedidos {
    list();
    return _itemPedidos;
  }
}