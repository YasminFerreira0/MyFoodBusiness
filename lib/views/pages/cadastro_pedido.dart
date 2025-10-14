import 'package:app/controllers/pedido_controller.dart';
import 'package:app/models/item_pedido.dart';
import 'package:app/utils/calcula_valor_total.dart';

import '../../models/pedido.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class CadastroPedido extends StatefulWidget {
  const CadastroPedido({super.key});

  @override
  State<CadastroPedido> createState() => _CadastroPedidoState();
}

class _CadastroPedidoState extends State<CadastroPedido> {
  final _formKey = GlobalKey<FormState>();
  final _pedidoController = PedidoController();

  final _numeroMesaController = TextEditingController();
  final _clienteIdController = TextEditingController();
  final _observacoesController = TextEditingController();

  String _statusSelecionado = 'Aberto';
  String _metodoPagamentoSelecionado = 'Dinheiro';

  final List<ItemPedido> _itensDoPedido = [];

  double get _totalGeral => _itensDoPedido.fold<double>(
    0,
    (soma, item) => soma + (item.precoUnitario * item.quantidade),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _numeroMesaController.dispose();
    _clienteIdController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  void _showAddItemDialog() {
    final produtoIdController = TextEditingController();
    final quantidadeController = TextEditingController();
    final dialogFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Item'),
          content: Form(
            key: dialogFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: produtoIdController,
                    decoration: const InputDecoration(
                      labelText: 'ID do Produto',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Campo obrigatório'
                        : null,
                  ),
                  TextFormField(
                    controller: quantidadeController,
                    decoration: const InputDecoration(labelText: 'Quantidade'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Campo obrigatório';
                      if (int.tryParse(value) == null || int.parse(value) <= 0)
                        return 'Quantidade inválida';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!dialogFormKey.currentState!.validate()) return;

                final produtoId = int.parse(produtoIdController.text);
                final quantidade = int.parse(quantidadeController.text);

                // busca o preço automaticamente
                final preco = await CalculaValorTotal.buscarPrecoProduto(
                  produtoId,
                );
                if (preco == null || preco <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Produto não encontrado ou sem preço cadastrado.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final newItem = ItemPedido(
                  produtoId: produtoId,
                  quantidade: quantidade,
                  precoUnitario: preco, // vem do banco via CalculaValorTotal
                );

                if (!context.mounted) return;
                setState(() => _itensDoPedido.add(newItem));
                Navigator.of(context).pop();
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _salvarPedido() async {
    if (_formKey.currentState!.validate()) {
      if (_itensDoPedido.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Adicione pelo menos um item ao pedido!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // O valorTotal será calculado pelo controller, aqui passamos 0 como placeholder.
      final novoPedido = Pedido(
        numeroMesa: _numeroMesaController.text.isNotEmpty
            ? int.parse(_numeroMesaController.text)
            : null,
        clienteId: _clienteIdController.text.isNotEmpty
            ? int.parse(_clienteIdController.text)
            : null,
        dataHora: DateTime.now(),
        status: _statusSelecionado,
        valorTotal: 0, // O controller irá calcular e substituir
        metodoPagamento: _metodoPagamentoSelecionado,
        observacoes: _observacoesController.text,
      );

      final pedidoId = await _pedidoController.insert(
        novoPedido,
        _itensDoPedido,
      );

      if (pedidoId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pedido #$pedidoId salvo com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        FocusScope.of(context).unfocus(); // fecha o teclado
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar o pedido.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Novo Pedido'),
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
                  labelText: 'Nº da Mesa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.table_restaurant),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
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
              DropdownButtonFormField<String>(
                value: _statusSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.info_outline),
                ),
                items:
                    [
                          'Aberto',
                          'Em preparação',
                          'Pronto',
                          'Entregue',
                          'Finalizado',
                        ]
                        .map(
                          (label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ),
                        )
                        .toList(),
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
                items:
                    ['Dinheiro', 'Cartão de Crédito', 'Cartão de Débito', 'Pix']
                        .map(
                          (label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ),
                        )
                        .toList(),
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
                    onPressed: _showAddItemDialog,
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
              // Mostra o total geral do pedido
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
                onPressed: () {
                  _salvarPedido();
                  _numeroMesaController.clear();
                  _clienteIdController.clear();
                  _observacoesController.clear();

                  setState(() {
                    _itensDoPedido.clear();
                    _statusSelecionado = 'Aberto';
                    _metodoPagamentoSelecionado = 'Dinheiro';
                  });
                },
                icon: const Icon(Icons.save),
                label: const Text('Salvar Pedido'),
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
