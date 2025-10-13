import 'package:flutter/material.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	Widget build(BuildContext context) {
		return MaterialApp(
			home: Scaffold(
				appBar: AppBar(title: Text('MyFoodBusiness')),
				body: Center(
					child: Text('em construção...'),
				),
			),
		);
	}
}
/*routes: {
        '/': (context) => const HomePage(), // tela home
        '/pedidos': (context) => const PedidosListPage(), // listpage
      },*/

/*Navigator.pushNamed(context, '/pedidos'); //chama a tela de listagem */