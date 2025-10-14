import 'package:app/data/dao/item_pedido_dao.dart';
import 'package:app/models/item_pedido.dart';
import 'package:flutter/material.dart';

class ItemPedidoController {
  final ItemPedidoDAO _dao = ItemPedidoDAO();

  Future<int?> insert(ItemPedido itemPedido) async {
    try {
      return await _dao.insert(itemPedido);
    } catch (e, stackTrace) {
      debugPrint("[ERROR] Erro de insert: $e\n$stackTrace");
      return null;
    }
  }

  Future<bool> update(ItemPedido itemPedido) async {
    try {
      int rowsAffected = await _dao.update(itemPedido);
      return rowsAffected != 0;
    } catch (e, stackTrace) {
      debugPrint("[ERROR] Erro de update: $e\n$stackTrace");
      return false;
    }
  }

  Future<bool> delete(int id) async {
    try {
      int rowsAffected = await _dao.delete(id);
      return rowsAffected != 0;
    } catch (e, stackTrace) {
      debugPrint("[ERROR] Erro de delete: $e\n$stackTrace");
      return false;
    }
  }

  Future<List<ItemPedido>> getItensByPedidoId(int id) async {
    try {
      return await _dao.getItensByPedidoId(id);
    } catch (e, stackTrace) {
      debugPrint("[ERROR] Erro de query: $e\n$stackTrace");
      return [];
    }
  }

  Future<List<ItemPedido>> list() async {
    try {
      return await _dao.list();
    } catch (e, stackTrace) {
      debugPrint("[ERROR] Erro de list: $e\n$stackTrace");
      return [];
    }
  }
}