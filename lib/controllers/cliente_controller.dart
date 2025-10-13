import 'package:app/data/dao/cliente_dao.dart';
import 'package:app/models/cliente.dart';
import 'package:flutter/material.dart';

class ClienteController {
  final ClienteDAO _dao = ClienteDAO();

  Future<int?> insert(Cliente cliente) async {
    try {
      return await _dao.insert(cliente);
    } catch (e, stackTrace) {
      debugPrint("[ERROR] Erro de insert: $e\n$stackTrace");
      return null;
    }
  }

  Future<bool> update(Cliente cliente) async {
    try {
      int rowsAffected = await _dao.update(cliente);
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

  Future<List<Cliente>> list() async {
    try {
      return await _dao.list();
    } catch (e, stackTrace) {
      debugPrint("[ERROR] Erro de list: $e\n$stackTrace");
      return [];
    }
  }
}