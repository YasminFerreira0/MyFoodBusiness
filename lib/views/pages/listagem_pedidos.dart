import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:app/controllers/item_pedido_controller.dart';
import 'package:app/models/item_pedido.dart';

class PedidosListPage extends StatefulWidget {
  const PedidosListPage({super.key});

  @override
  State<PedidosListPage> createState() => _PedidosListPageState();
}

class _PedidosListPageState extends State<PedidosListPage> {
  final ItemPedidoController _itemCtrl = ItemPedidoController();

  // pedidoId -> itens
  Map<int, List<ItemPedido>> _pedidos = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarPedidos();
  }

  Future<void> _carregarPedidos() async {
    setState(() => _isLoading = true);

    // carrega todos os itens e agrupa por pedidoId (sem usar DAO direto)
    final itens = await _itemCtrl.list();
    final agrupado = <int, List<ItemPedido>>{};
    for (final it in itens) {
      final pid = it.pedidoId;
      if (pid == null) continue; // ignora itens sem vínculo
      agrupado.putIfAbsent(pid, () => []);
      agrupado[pid]!.add(it);
    }

    // ordena os pedidos por id desc (opcional) e itens por id asc
    final sortedKeys = agrupado.keys.toList()..sort((a, b) => b.compareTo(a));
    final sortedMap = <int, List<ItemPedido>>{};
    for (final k in sortedKeys) {
      agrupado[k]!.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
      sortedMap[k] = agrupado[k]!;
    }

    if (!mounted) return;
    setState(() {
      _pedidos = sortedMap;
      _isLoading = false;
    });
  }

  double _totalDoPedido(List<ItemPedido> itens) {
    return itens.fold<double>(
      0,
      (s, i) => s + (i.precoUnitario * i.quantidade),
    );
  }

  Future<void> _excluirPedido(int pedidoId) async {
    // Sem alterar controllers: apaga todos os itens daquele pedido aqui na tela
    final itens = _pedidos[pedidoId] ?? [];
    var ok = true;
    for (final it in itens) {
      if (it.id == null) continue;
      final deleted = await _itemCtrl.delete(it.id!);
      ok = ok && deleted;
    }

    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pedido #$pedidoId excluído (itens removidos).')),
      );
      await _carregarPedidos();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao excluir um ou mais itens do pedido.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmarExclusao(int pedidoId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir pedido'),
        content: const Text(
          'Isso removerá todos os itens vinculados a este pedido. Deseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _excluirPedido(pedidoId);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPedidos = _pedidos.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listagem de Pedidos'),
        backgroundColor: Colors.red,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : !hasPedidos
              ? const Center(child: Text('Nenhum pedido cadastrado.'))
              : ListView.builder(
                  itemCount: _pedidos.length,
                  itemBuilder: (context, index) {
                    final pedidoId = _pedidos.keys.elementAt(index);
                    final itens = _pedidos[pedidoId]!;
                    final total = _totalDoPedido(itens);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                        title: Text('Pedido #$pedidoId'),
                        subtitle: Text(
                          '${Utils.calcTotalItensPorPedido(itens)} itens(m) • Total: R\$ ${total.toStringAsFixed(2)}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmarExclusao(pedidoId),
                          tooltip: 'Excluir pedido',
                        ),
                        children: [
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: itens.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Produto: ${item.produtoId} • Qtd: ${item.quantidade}',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        'R\$ ${(item.precoUnitario*item.quantidade).toStringAsFixed(2)}',
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
