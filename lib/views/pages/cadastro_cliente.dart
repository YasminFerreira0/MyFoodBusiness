import '../../data/dao/cliente_dao.dart';
import '../../models/cliente.dart';
import 'package:flutter/material.dart';
import '../drawer/app_drawer.dart';

class CadastroCliente extends StatefulWidget {
  const CadastroCliente({super.key});

  @override
  State<CadastroCliente> createState() => _CadastroClienteState();
}

class _CadastroClienteState extends State<CadastroCliente> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();

  final ClienteDAO _clienteDao = ClienteDAO();

  void _salvarCliente() async {
    if (_formKey.currentState!.validate()) {

      final cliente = Cliente(
        nome: _nomeController.text,
        telefone: _telefoneController.text,
        email: _emailController.text,
        cpf: _cpfController.text,
      );

      await _clienteDao.insert(cliente);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente ${cliente.nome} cadastrado com sucesso!')),
      );

      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Cliente')),
      drawer: MeuDrawer(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CPF';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarCliente,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
