import 'package:app/views/pages/cadastro_pedido.dart';
import 'package:app/views/drawer/app_drawer.dart';
import 'package:app/views/pages/cadastro_produto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: MeuDrawer(),
      body: Column(
        children: [
          _botoesUtilitarios(context),
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Recomendações',
              style: theme.textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 15),
          Container(),
        ],
      ),
    );
  }

  Column _botoesUtilitarios(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _searchField(context),
        const SizedBox(height: 20),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Utilitários',
                style: theme.textTheme.headlineSmall, //do tema
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CadastroPedido()),
                          );
                        },
                        child: const Icon(Icons.fastfood),
                        
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                      ),
                      Text(' Cadastrar\nComandas',
                        style: theme.textTheme.bodyMedium, 
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CadastroProduto()),
                          );
                        },
                        child: const Icon(Icons.food_bank),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                      ),
                      Text('Cadastrar\ndo Cardápio',
                        style: theme.textTheme.bodyMedium, 
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _searchField(BuildContext context) {
    return SizedBox(
      height: 70,
      child: const Padding(
        padding: EdgeInsets.only(top: 30),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(Icons.search),
            ),
            hintText: 'Pesquisar Petiscos...',
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AppBar(
      title: Text(
        'MyFoodBusiness',
        style: theme.textTheme.titleLarge?.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: theme.appBarTheme.foregroundColor ?? cs.onSurface,
        ),
      ),
      centerTitle: true,
      leading: Builder(
        builder: (context) => GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Container(
            margin: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              'assets/icons/align-left-svgrepo-com.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                theme.appBarTheme.foregroundColor ?? cs.onSurface,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
