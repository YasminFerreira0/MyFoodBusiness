import 'package:app/views/widgets/app_drawer.dart';
import 'package:app/data/dao/item_pedido_dao.dart';
import 'package:flutter/material.dart';
import 'package:app/models/item_pedido.dart';

class PedidosListPage extends StatefulWidget {
  const PedidosListPage({super.key});

  @override
  State<PedidosListPage> createState() => _PedidosListPageState();
}

class _PedidosListPageState extends State<PedidosListPage> {
  final ItemPedidoDAO _dao = ItemPedidoDAO();
  List<ItemPedido> _pedidos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarPedidos();
  }

  Future<void> _carregarPedidos() async {
    final pedidos = await _dao.list();
    setState(() {
      _pedidos = pedidos;
      _isLoading = false;
    });
  }

  Future<void> _excluirPedido(int id) async {
    await _dao.delete(id);
    _carregarPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listagem de Pedidos'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      drawer: MeuDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pedidos.isEmpty
              ? const Center(child: Text('Nenhum pedido cadastrado.'))
              : RefreshIndicator(
                  onRefresh: _carregarPedidos,
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: _pedidos.length,
                    itemBuilder: (context, index) {
                      final pedido = _pedidos[index];
                      final total =
                          pedido.quantidade * pedido.precoUnitario; // 💰 total calculado

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade100,
                            child: Text(
                              (pedido.id ?? '').toString(),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          title: Text(
                            'Pedido ID: ${pedido.id}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Produto ID: ${pedido.produtoId}'),
                                Text(
                                    'Quantidade: ${pedido.quantidade}\nPreço unitário: R\$ ${pedido.precoUnitario.toStringAsFixed(2)}'),
                                const SizedBox(height: 4),
                                Text(
                                  'Valor Total: R\$ ${total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmarExclusao(pedido.id!),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void _confirmarExclusao(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Pedido'),
        content: const Text('Tem certeza que deseja excluir este pedido?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _excluirPedido(id);
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
