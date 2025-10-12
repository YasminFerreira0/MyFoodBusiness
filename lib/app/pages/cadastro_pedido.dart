import 'package:app/dao/PedidoDAO.dart';
import 'package:app/models/Pedido.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class CadastroPedido extends StatefulWidget {
  const CadastroPedido({super.key});

  @override
  State<CadastroPedido> createState() => _CadastroPedidoState();
}

class _CadastroPedidoState extends State<CadastroPedido> {
  final _formKey = GlobalKey<FormState>();
  final _clienteIdController = TextEditingController();
  final _statusController = TextEditingController();
  final _valorTotalController = TextEditingController();
  final _metodoPagamentoController = TextEditingController();
  final _observacoesController = TextEditingController();

  final PedidoDAO _pedidoDao = PedidoDAO();

  void _salvarPedido() async {
    if (_formKey.currentState!.validate()) {
      final agora = DateTime.now();

      final pedido = Pedido(
        clienteId: int.parse(_clienteIdController.text),
        dataHora: agora,
        status: _statusController.text,
        valorTotal: double.parse(_valorTotalController.text),
        metodoPagamento: _metodoPagamentoController.text,
        observacoes: _observacoesController.text.isNotEmpty ? _observacoesController.text : null,
        
      );

      await _pedidoDao.insert(pedido);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pedido cadastrado com sucesso!')),
      );

      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Pedido')),
      drawer: MeuDrawer(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _clienteIdController,
                decoration: const InputDecoration(labelText: 'ID do Cliente'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o ID do cliente';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um ID válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o status';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valorTotalController,
                decoration: const InputDecoration(labelText: 'Valor Total'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um valor válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _metodoPagamentoController,
                decoration: const InputDecoration(labelText: 'Método de Pagamento'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o método de pagamento';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _observacoesController,
                decoration: const InputDecoration(labelText: 'Observações (opcional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarPedido,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}