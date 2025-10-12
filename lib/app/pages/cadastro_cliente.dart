import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class CadastroCliente extends StatefulWidget {
  const CadastroCliente({super.key});

  @override
  State<CadastroCliente> createState() => _CadastroClienteState();
}

class _CadastroClienteState extends State<CadastroCliente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Cliente')),
      drawer: MeuDrawer(),
      body: const Center(child: Text('Tela de Cadastro de Cliente')),
    );
  }
}
