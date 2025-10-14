import 'package:app/views/pages/cadastro_pedido.dart';
import 'package:app/views/pages/cadastro_produto.dart';
import 'package:app/views/pages/listagem_pedidos.dart';
import 'package:app/views/pages/listagem_produtos.dart';
import 'package:flutter/material.dart';
import '../pages/cadastro_cliente.dart';

class MeuDrawer extends Drawer {
  MeuDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.red),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('Cadastro de Cliente'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CadastroCliente()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add_shopping_cart),
            title: Text('Cadastro de Pedido'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CadastroPedido()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.inventory),
            title: Text('Cadastro de Produto'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CadastroProduto()));
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Listagem de Pedidos'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PedidosListPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Listagem de Produtos'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProdutoListPage()));
            },
          ),
        ],
      ),
    );
  }
}