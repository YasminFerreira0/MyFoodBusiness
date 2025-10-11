import 'package:app/dao/DatabaseHelper.dart';
import 'package:app/models/Produto.dart';
import 'package:sqflite/sqflite.dart';

class ProdutoDAO {
  List<Map<String, dynamic>> _produtos = [];

  Future<void> insert(Produto produto) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert(
      'produto',
      produto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertSQL(Produto produto) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.rawInsert(
      'INSERT INTO produto(nome, preco, categoria, descricao) VALUES(?, ?, ?, ?)', 
      [produto.nome, produto.preco, produto.categoria, produto.descricao]
    );
  }

  Future<void> update(Produto produto) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.update(
      'produto',
      produto.toMap(),
      where: "id = ?",
      whereArgs: [produto.id],
    );
  }

  Future<void> updateSQL(Produto produto) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.rawUpdate('UPDATE produto SET nome = ?, preco = ?, categoria = ?, descricao = ? WHERE id = ?', [
      produto.nome,
      produto.preco,
      produto.categoria,
      produto.descricao,
      produto.id,
    ]);
  }

  Future<void> delete(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.delete(
      'produto', 
      where: "id = ?", 
      whereArgs: [id]
    );
  }

  Future<void> deleteSQL(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.rawDelete('DELETE FROM produto WHERE id = ?', [id]);
  }

  Future<List<Produto>> list() async {
    final Database db = await DatabaseHelper.instance.database;
    _produtos = await db.query('produto');
    return List.generate(_produtos.length, (i) {
      return Produto.fromMap(_produtos[i]);
    });
  }

  List get produtos {
    list();
    return _produtos;
  }
}