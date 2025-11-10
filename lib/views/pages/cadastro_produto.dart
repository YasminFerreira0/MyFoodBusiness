import 'package:app/controllers/produto_controller.dart';
import 'package:flutter/material.dart';
import 'package:app/views/drawer/app_drawer.dart';

import '../../models/produto.dart';
import '../../models/categoria_produto.dart';

class CadastroProduto extends StatefulWidget {
  const CadastroProduto({super.key});

  @override
  _CadastroProdutoState createState() => _CadastroProdutoState();
}

class _CadastroProdutoState extends State<CadastroProduto> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  final ProdutoController _produtoController = ProdutoController();
  CategoriaProduto? _categoriaSelecionada;

  void _salvarProduto() async {
    if (_formKey.currentState!.validate()) {
      // Fecha o teclado
      FocusScope.of(context).unfocus();

      final produto = Produto(
        nome: _nomeController.text,
        preco: double.parse(_precoController.text.replaceAll(',', '.')),
        categoria: _categoriaSelecionada!,
        descricao: _descricaoController.text,
      );

      await _produtoController.insert(produto);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item cadastrado com sucesso!')),
      );

      // Reseta o formulário (para limpar validações)
      _formKey.currentState!.reset();

      // Limpa a categoria selecionada
      setState(() {
        _categoriaSelecionada = null;
      });
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro do Cardápio')),
      drawer: MeuDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Item'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do Item';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _precoController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço';
                  }
                  if (double.tryParse(value.replaceAll(',', '.')) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<CategoriaProduto>(
                value: _categoriaSelecionada,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: CategoriaProduto.values.map((categoria) {
                  return DropdownMenuItem(
                    value: categoria,
                    child: Text(
                      categoria.label,
                    ),
                  );
                }).toList(),
                onChanged: (novaCategoria) {
                  setState(() {
                    _categoriaSelecionada = novaCategoria;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione uma categoria';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _salvarProduto();

                  _nomeController.clear();
                  _precoController.clear();
                  _descricaoController.clear();
                },
                child: const Text('Salvar Item do Cardápio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
