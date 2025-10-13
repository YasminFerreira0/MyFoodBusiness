import 'package:app/controllers/item_pedido_controller.dart';
import 'package:app/data/dao/pedido_dao.dart';
import 'package:app/models/item_pedido.dart';
import 'package:app/models/pedido.dart';
import 'package:flutter/material.dart';

class PedidoController {
  final PedidoDAO _dao = PedidoDAO();

  Future<int?> insert(Pedido pedido, List<ItemPedido> itens) async {
    try {
      double total = itens.fold(0, (sum, item) => sum + (item.precoUnitario * item.quantidade));
      pedido.valorTotal = total;
      int pedidoId = await _dao.insert(pedido);

      final ItemPedidoController ipc = ItemPedidoController();
      for (var item in itens) {
        item.pedidoId = pedidoId;
        await ipc.insert(item);
      }

      return pedidoId;
    } catch (e, stackTrace) {
      debugPrint("[ERROR] Erro de insert: $e\n$stackTrace");
      return null;
    }
  }

  Future<bool> update(Pedido pedido) async {
    try {
      int rowsAffected = await _dao.update(pedido);
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

  Future<List<Pedido>> list() async {
    try {
      return await _dao.list();
    } catch (e, stackTrace) {
      debugPrint("[ERROR] Erro de list: $e\n$stackTrace");
      return [];
    }
  }
}