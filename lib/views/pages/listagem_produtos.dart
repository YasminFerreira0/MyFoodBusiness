import 'package:app/views/pages/cadastro_produto.dart';
import 'package:flutter/material.dart';
import 'package:app/views/widgets/app_drawer.dart';
import 'package:app/controllers/produto_controller.dart';
import 'package:app/models/produto.dart';

class ProdutoListPage extends StatefulWidget {
  const ProdutoListPage({super.key});

  @override
  State<ProdutoListPage> createState() => _ProdutoListPageState();
}

class _ProdutoListPageState extends State<ProdutoListPage> {
  final ProdutoController _controller = ProdutoController();

  List<Produto> _produtos = [];
  bool _isLoading = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      final produtos = await _controller.list();
      if (!mounted) return;
      setState(() {
        _produtos = produtos;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMsg = 'Erro ao carregar produtos: $e';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _excluirProduto(int id) async {
    final ok = await _controller.delete(id);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Produto excluído.')));
      _carregarProdutos();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao excluir produto.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool?> _confirmarExclusao(Produto p) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Produto'),
        content: Text('Tem certeza que deseja excluir "${p.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMsg != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 10),
              Text(_errorMsg!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _carregarProdutos,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_produtos.isEmpty) {
      return const Center(child: Text('Nenhum produto cadastrado.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: _produtos.length,
      itemBuilder: (context, index) {
        final p = _produtos[index];

        final id = p.id?.toString() ?? '?';
        final nome = p.nome ?? '(Sem nome)';
        final preco = (p.preco is num)
            ? (p.preco as num).toDouble()
            : double.tryParse('${p.preco}') ?? 0.0;
        final categoria = p.categoria ?? 'Sem categoria';
        final desc = p.descricao ?? 'Sem descrição';

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple.shade100,
              child: Text(id, style: const TextStyle(color: Colors.red)),
            ),
            title: Text(
              nome,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('Categoria: $categoria'),
                  const SizedBox(height: 4),
                  Text(
                    'Preço: R\$ ${preco.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Excluir',
              onPressed: () async {
                final ok = await _confirmarExclusao(p);
                if (ok == true && p.id != null) _excluirProduto(p.id!);
              },
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Produtos'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      drawer: MeuDrawer(),
      body: RefreshIndicator(onRefresh: _carregarProdutos, child: _buildBody()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastroProduto()),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }
}
