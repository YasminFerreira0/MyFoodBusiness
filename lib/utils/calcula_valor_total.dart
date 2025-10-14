import 'package:app/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class CalculaValorTotal {
  /// Retorna o preço unitário de um produto pelo ID.
  static Future<double?> buscarPrecoProduto(int produtoId) async {
    final Database db = await DatabaseHelper.instance.database;

    final res = await db.query(
      'produto',              // nome da tabela
      columns: ['preco'],     // nome da coluna de preço (ajuste conforme seu banco)
      where: 'id = ?',
      whereArgs: [produtoId],
      limit: 1,
    );

    if (res.isEmpty) return null;

    final value = res.first['preco'];
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  /// Calcula o valor total de um item: quantidade * preçoUnitário.
  static Future<double?> calcularItem(int produtoId, int quantidade) async {
    final preco = await buscarPrecoProduto(produtoId);
    if (preco == null) return null;
    return preco * quantidade;
  }

  /// Calcula o total de um pedido inteiro (soma de todos os itens).
  static Future<double> calcularPedido(
      List<Map<String, dynamic>> itens) async {
    double total = 0;
    for (var item in itens) {
      final produtoId = item['produtoId'] as int;
      final quantidade = item['quantidade'] as int;
      final preco = await buscarPrecoProduto(produtoId);
      if (preco != null) total += preco * quantidade;
    }
    return total;
  }
}
