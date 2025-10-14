import 'package:flutter/material.dart';
import 'package:app/views/widgets/app_drawer.dart';

import '../../data/dao/produto_dao.dart';
import '../../models/produto.dart';
import '../../models/categoria_produto.dart';

class CadastroProduto extends StatefulWidget {
  @override
  _CadastroProdutoState createState() => _CadastroProdutoState();
}

class _CadastroProdutoState extends State<CadastroProduto> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  final ProdutoDAO _produtoDAO = ProdutoDAO();
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

      await _produtoDAO.insert(produto);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto cadastrado com sucesso!')),
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
      appBar: AppBar(title: const Text('Cadastro de Produto')),
      drawer: MeuDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do produto';
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
                      categoria.name[0].toUpperCase() +
                          categoria.name.substring(1),
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
                child: const Text('Salvar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
