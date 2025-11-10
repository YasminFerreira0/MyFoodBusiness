import 'package:flutter/material.dart';
import 'package:app/controllers/produto_controller.dart';
import 'package:app/models/produto.dart';
import 'package:app/models/item_pedido.dart';

class SelecionarItensPedidoPage extends StatefulWidget {
  const SelecionarItensPedidoPage({super.key});

  @override
  State<SelecionarItensPedidoPage> createState() => _SelecionarItensPedidoPageState();
}

class _SelecionarItensPedidoPageState extends State<SelecionarItensPedidoPage> {
  final _controller = ProdutoController();

  bool _loading = true;
  String? _error;
  List<Produto> _produtos = [];

  // produtoId -> quantidade
  final Map<int, int> _quantidades = {};

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() { _loading = true; _error = null; });
    try {
      final lista = await _controller.list();
      if (!mounted) return;
      setState(() {
        _produtos = lista;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = 'Erro ao carregar cardápio: $e'; });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  void _incrementar(int produtoId) {
    setState(() {
      _quantidades.update(produtoId, (q) => q + 1, ifAbsent: () => 1);
    });
  }

  void _decrementar(int produtoId) {
    setState(() {
      final atual = _quantidades[produtoId] ?? 0;
      if (atual <= 1) {
        _quantidades.remove(produtoId);
      } else {
        _quantidades[produtoId] = atual - 1;
      }
    });
  }

  void _concluir() {
    // Constrói a lista de ItemPedido e devolve para a tela anterior
    final itens = <ItemPedido>[];
    for (final entry in _quantidades.entries) {
      final produtoId = entry.key;
      final qtd = entry.value;

      final p = _produtos.firstWhere((e) => e.id == produtoId, orElse: () => Produto.empty());
      final preco = (p.preco as num?)?.toDouble() ?? 0;

      if (qtd > 0 && preco > 0) {
        itens.add(ItemPedido(
          produtoId: produtoId,
          quantidade: qtd,
          precoUnitario: preco,
        ));
      }
    }

    Navigator.of(context).pop(itens);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar itens ao pedido'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 42),
                        const SizedBox(height: 12),
                        Text(_error!, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _carregar,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                )
              : _produtos.isEmpty
                  ? const Center(child: Text('Nenhum item no cardápio.'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      itemCount: _produtos.length,
                      itemBuilder: (context, index) {
                        final p = _produtos[index];
                        final id = p.id;
                        if (id == null) return const SizedBox.shrink();

                        final qtd = _quantidades[id] ?? 0;
                        final preco = (p.preco as num?)?.toDouble() ?? 0;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(p.nome.isNotEmpty ? p.nome : '(Sem nome)'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.descricao ?? 'Sem descrição'),
                                const SizedBox(height: 4),
                                Text('Preço: R\$ ${preco.toStringAsFixed(2)}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Remover',
                                  onPressed: qtd > 0 ? () => _decrementar(id) : null,
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text('$qtd', style: const TextStyle(fontWeight: FontWeight.bold)),
                                IconButton(
                                  tooltip: 'Adicionar',
                                  onPressed: () => _incrementar(id),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          onPressed: _quantidades.isEmpty ? null : _concluir,
          icon: const Icon(Icons.check),
          label: const Text('Concluir seleção'),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
        ),
      ),
    );
  }
}
