import 'package:app/controllers/produto_controller.dart';
import 'package:app/models/item_pedido.dart';
import 'package:app/models/produto.dart';

class Utils {
  ProdutoController _controller = ProdutoController();

  /// Calcula o valor total de um item: quantidade * preçoUnitário.
  Future<double?> calcularItem(int produtoId, int quantidade) async {
    Produto? prod = await _controller.getProdutoById(produtoId);
    return prod==null ? null : prod.preco * quantidade;
  }

  /// Calcula o total de um pedido inteiro (soma de todos os itens).
  Future<double> calcularPedido(List<Map<String, dynamic>> itens) async {
    double total = 0;
    for (var item in itens) {
      final produtoId = item['produtoId'] as int;
      final quantidade = item['quantidade'] as int;
      Produto? prod = await _controller.getProdutoById(produtoId);
      prod==null ? null : total += prod.preco * quantidade;
    }
    return total;
  }

  static int calcTotalItensPorPedido(List<ItemPedido> itens) {
    int total = 0;
    for (var item in itens) {
      total += item.quantidade;  
    }
    return total;
  }
}
