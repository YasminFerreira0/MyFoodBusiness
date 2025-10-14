import 'package:app/data/database_helper.dart';
import 'package:app/models/produto.dart';
import 'package:sqflite/sqflite.dart';

class ProdutoDAO {
  Future<Produto> getProdutoById(int id) async {
    final Database db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> query = await db.query(
      'produto',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    Produto p = Produto.fromMap(query.first);
    return p;
  }

  Future<int> insert(Produto produto) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(
      'produto',
      produto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update(Produto produto) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.update(
      'produto',
      produto.toMap(),
      where: "id = ?",
      whereArgs: [produto.id],
    );
  }

  Future<int> delete(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(
      'produto', 
      where: "id = ?", 
      whereArgs: [id]
    );
  }

  Future<List<Produto>> list() async {
    final Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> produtos = await db.query('produto');
    return List.generate(produtos.length, (i) {
      return Produto.fromMap(produtos[i]);
    });
  }
}