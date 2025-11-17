import 'package:flutter/material.dart';
import 'package:app/controllers/pedido_controller.dart';
import 'package:app/controllers/item_pedido_controller.dart';
import 'package:app/models/pedido.dart';
import 'package:app/models/item_pedido.dart';
import 'package:app/utils/utils.dart';
import 'package:app/views/pages/selecionar_itens_pedido.dart';

import '../drawer/app_drawer.dart';

class EditarPedidoPage extends StatefulWidget {
  final int pedidoId;

  const EditarPedidoPage({super.key, required this.pedidoId});

  @override
  State<EditarPedidoPage> createState() => _EditarPedidoPageState();
}

class _EditarPedidoPageState extends State<EditarPedidoPage> {
  final _formKey = GlobalKey<FormState>();

  final _pedidoController = PedidoController();
  final _itemPedidoController = ItemPedidoController();

  final _numeroMesaController = TextEditingController();
  final _clienteIdController = TextEditingController();
  final _observacoesController = TextEditingController();

  String _statusSelecionado = 'Aberto';
  String _metodoPagamentoSelecionado = 'Dinheiro';

  final List<ItemPedido> _itensDoPedido = [];

  bool _carregando = true;

  double get _totalGeral => _itensDoPedido.fold<double>(
        0,
        (soma, item) => soma + (item.precoUnitario * item.quantidade),
      );

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _numeroMesaController.dispose();
    _clienteIdController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    setState(() => _carregando = true);

    try {
      // Carrega o pedido pela lista (sem precisar de getById no DAO)
      final pedidos = await _pedidoController.list();
      Pedido? pedido;
      for (final p in pedidos) {
        if (p.id == widget.pedidoId) {
          pedido = p;
          break;
        }
      }

      if (pedido == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pedido #${widget.pedidoId} não encontrado.')),
        );
        Navigator.of(context).pop();
        return;
      }

      // Preenche os campos do formulário
      _numeroMesaController.text =
          pedido.numeroMesa != null ? pedido.numeroMesa.toString() : '';
      _clienteIdController.text =
          pedido.clienteId != null ? pedido.clienteId.toString() : '';
      _observacoesController.text = pedido.observacoes ?? '';

      _statusSelecionado = pedido.status ?? 'Aberto';
      _metodoPagamentoSelecionado = pedido.metodoPagamento ?? 'Dinheiro';

      // Carrega os itens do pedido
      final itens = await _itemPedidoController.getItensByPedidoId(widget.pedidoId);

      if (!mounted) return;
      setState(() {
        _itensDoPedido
          ..clear()
          ..addAll(itens);
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar pedido: $e')),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _abrirSelecaoDeItens() async {
    final selecionados = await Navigator.of(context).push<List<ItemPedido>>(
      MaterialPageRoute(builder: (_) => const SelecionarItensPedidoPage()),
    );

    if (!mounted) return;
    if (selecionados == null || selecionados.isEmpty) return;

    setState(() {
      _mesclarItens(_itensDoPedido, selecionados);
    });
  }

  /// Mescla itens por produtoId (mesma lógica do cadastro)
  void _mesclarItens(List<ItemPedido> destino, List<ItemPedido> novos) {
    final mapa = <int, ItemPedido>{};

    for (final item in destino) {
      mapa[item.produtoId] = ItemPedido(
        id: item.id,
        pedidoId: item.pedidoId,
        produtoId: item.produtoId,
        quantidade: item.quantidade,
        precoUnitario: item.precoUnitario,
      );
    }

    for (final n in novos) {
      final existente = mapa[n.produtoId];
      if (existente == null) {
        mapa[n.produtoId] = ItemPedido(
          produtoId: n.produtoId,
          quantidade: n.quantidade,
          precoUnitario: n.precoUnitario,
        );
      } else {
        mapa[n.produtoId] = ItemPedido(
          id: existente.id,
          pedidoId: existente.pedidoId,
          produtoId: existente.produtoId,
          quantidade: existente.quantidade + n.quantidade,
          precoUnitario: existente.precoUnitario,
        );
      }
    }

    destino
      ..clear()
      ..addAll(mapa.values);
  }

  Future<void> _salvarEdicao() async {
    if (!_formKey.currentState!.validate()) return;

    if (_itensDoPedido.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione pelo menos um item ao pedido!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Monta lista para o Utils.calcularPedido
    final itensParaUtil = _itensDoPedido
        .map<Map<String, dynamic>>(
          (i) => {'produtoId': i.produtoId, 'quantidade': i.quantidade},
        )
        .toList();

    final utils = Utils();
    final valorTotalCalculado = await utils.calcularPedido(itensParaUtil);

    final pedidoAtualizado = Pedido(
      id: widget.pedidoId,
      numeroMesa: _numeroMesaController.text.isNotEmpty
          ? int.parse(_numeroMesaController.text)
          : null,
      clienteId: _clienteIdController.text.isNotEmpty
          ? int.parse(_clienteIdController.text)
          : null,
      dataHora: DateTime.now(), // ou mantenha a data original se preferir
      status: _statusSelecionado,
      valorTotal: valorTotalCalculado,
      metodoPagamento: _metodoPagamentoSelecionado,
      observacoes: _observacoesController.text,
    );

    try {
      // Atualiza o pedido
      final okPedido = await _pedidoController.update(pedidoAtualizado);

      if (!okPedido) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao atualizar os dados do pedido.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Estratégia simples: remove todos os itens antigos e insere os novos
      final itensAntigos =
          await _itemPedidoController.getItensByPedidoId(widget.pedidoId);

      for (final it in itensAntigos) {
        if (it.id != null) {
          await _itemPedidoController.delete(it.id!);
        }
      }

      for (final item in _itensDoPedido) {
        item.pedidoId = widget.pedidoId;
        await _itemPedidoController.insert(item);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pedido #${widget.pedidoId} atualizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(true); // volta indicando que houve alteração
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar alterações: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Pedido #${widget.pedidoId}'),
        centerTitle: true,
      ),
      drawer: MeuDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Dados do Pedido',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _numeroMesaController,
                decoration: const InputDecoration(
                  labelText: 'Nº da Comanda',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.confirmation_number_outlined),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              // Caso queira voltar a usar o clienteId, é só descomentar:
              /*
              TextFormField(
                controller: _clienteIdController,
                decoration: const InputDecoration(
                  labelText: 'ID do Cliente (Opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              */
              DropdownButtonFormField<String>(
                value: _statusSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.info_outline),
                ),
                items: const [
                  'Aberto',
                  'Em preparação',
                  'Pronto',
                  'Entregue',
                  'Finalizado',
                ].map(
                  (label) {
                    return DropdownMenuItem(
                      value: label,
                      child: Text(label),
                    );
                  },
                ).toList(),
                onChanged: (value) =>
                    setState(() => _statusSelecionado = value!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _metodoPagamentoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Método de Pagamento',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.payment),
                ),
                items: const [
                  'Dinheiro',
                  'Cartão de Crédito',
                  'Cartão de Débito',
                  'Pix',
                ].map(
                  (label) {
                    return DropdownMenuItem(
                      value: label,
                      child: Text(label),
                    );
                  },
                ).toList(),
                onChanged: (value) =>
                    setState(() => _metodoPagamentoSelecionado = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _observacoesController,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.comment),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Itens do Pedido',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.blue,
                      size: 30,
                    ),
                    onPressed: _abrirSelecaoDeItens,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _itensDoPedido.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Nenhum item adicionado.'),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _itensDoPedido.length,
                      itemBuilder: (context, index) {
                        final item = _itensDoPedido[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text('Produto ID: ${item.produtoId}'),
                            subtitle: Text(
                              'Qtd: ${item.quantidade} x R\$ ${item.precoUnitario.toStringAsFixed(2)}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'R\$ ${(item.quantidade * item.precoUnitario).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => setState(
                                    () => _itensDoPedido.removeAt(index),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              if (_itensDoPedido.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, right: 4),
                    child: Text(
                      'Total do Pedido: R\$ ${_totalGeral.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _salvarEdicao,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Alterações'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
