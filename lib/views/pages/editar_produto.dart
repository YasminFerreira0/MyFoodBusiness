import 'package:flutter/material.dart';
import 'package:app/controllers/produto_controller.dart';
import 'package:app/models/produto.dart';
import 'package:app/models/categoria_produto.dart';

class EditarProdutoPage extends StatefulWidget {
  final Produto produto;

  const EditarProdutoPage({
    super.key,
    required this.produto,
  });

  @override
  State<EditarProdutoPage> createState() => _EditarProdutoPageState();
}

class _EditarProdutoPageState extends State<EditarProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  final ProdutoController _produtoController = ProdutoController();

  late TextEditingController _nomeController;
  late TextEditingController _precoController;
  late TextEditingController _descricaoController;
  CategoriaProduto? _categoriaSelecionada;

  bool _salvando = false;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(text: widget.produto.nome);
    _precoController =
        TextEditingController(text: widget.produto.preco.toStringAsFixed(2));
    _descricaoController =
        TextEditingController(text: widget.produto.descricao ?? '');

    _categoriaSelecionada = widget.produto.categoria;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoriaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma categoria.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _salvando = true);
    FocusScope.of(context).unfocus();

    try {
      final preco = double.tryParse(
              _precoController.text.replaceAll('.', '').replaceAll(',', '.')) ??
          double.tryParse(_precoController.text.replaceAll(',', '.')) ??
          0.0;

      final produtoAtualizado = Produto(
        id: widget.produto.id,
        nome: _nomeController.text.trim(),
        preco: preco,
        categoria: _categoriaSelecionada!,
        descricao: _descricaoController.text.trim().isEmpty
            ? null
            : _descricaoController.text.trim(),
      );

      final ok = await _produtoController.update(produtoAtualizado);

      if (!mounted) return;

      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item do cardápio atualizado com sucesso.')),
        );
        Navigator.pop(context, true); // volta informando que salvou
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao atualizar item do cardápio.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Item do Cardápio'),
        centerTitle: true,
        backgroundColor: scheme.surface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do item',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o nome do item.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _precoController,
                  decoration: const InputDecoration(
                    labelText: 'Preço (R\$)',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o preço.';
                    }
                    final v = double.tryParse(
                            value.replaceAll('.', '').replaceAll(',', '.')) ??
                        double.tryParse(value.replaceAll(',', '.'));
                    if (v == null || v <= 0) {
                      return 'Informe um preço válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<CategoriaProduto>(
                  value: _categoriaSelecionada,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                  ),
                  items: CategoriaProduto.values
                      .map(
                        (c) => DropdownMenuItem<CategoriaProduto>(
                          value: c,
                          child: Text(c.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _categoriaSelecionada = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _salvando
                            ? null
                            : () {
                                Navigator.pop(context, false);
                              },
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _salvando ? null : _salvar,
                        child: _salvando
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Salvar alterações'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
