import 'package:flutter/material.dart';
import 'package:app/dao/ItemPedidoDAO.dart'; 
import 'package:app/models/ItemPedido.dart';

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
    _carregarPedidos(); // att a lista
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listagem de Pedidos'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pedidos.isEmpty
              ? const Center(child: Text('Nenhum pedido cadastrado.'))
              : ListView.builder(
                  itemCount: _pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = _pedidos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text('Pedido ID: ${pedido.id}'),
                        subtitle: Text(
                          'Produto: ${pedido.produtoId} • Quantidade: ${pedido.quantidade}\nPreço unitário: R\$${pedido.precoUnitario.toStringAsFixed(2)}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmarExclusao(pedido.id!),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _confirmarExclusao(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir pedido'),
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
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
