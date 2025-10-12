import 'package:app/app/pages/cadastro_pedido.dart';
import 'package:flutter/material.dart';
import '../pages/cadastro_cliente.dart';

class MeuDrawer extends Drawer {
  MeuDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
          )
        ],
      ),
    );
  }
}