import 'package:app/data/dao/produto_dao.dart';
import 'package:app/models/produto.dart';
import 'package:flutter/rendering.dart';

class ProdutoController {
  final ProdutoDAO _dao = ProdutoDAO();

  Future<Produto?> getProdutoById(int id) async {
    try {
      return await _dao.getProdutoById(id);
    } catch (e, stackTrace) {
      debugPrint("[ERROR] Erro de query: $e\n$stackTrace");
      return null;
    }
  }

  Future<int?> insert(Produto produto) async {
    try {
      return await _dao.insert(produto);
    } catch (e, stackTrace) {
      debugPrint("[ERROR] Erro de insert: $e\n$stackTrace");
      return null;
    }
  }

  Future<bool> update(Produto produto) async {
    try {
      int rowsAffected = await _dao.update(produto);
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

  Future<List<Produto>> list() async {
    try {
      return await _dao.list();
    } catch (e, stackTrace) {
      debugPrint("[ERROR] Erro de list: $e\n$stackTrace");
      return [];
    }
  }
}