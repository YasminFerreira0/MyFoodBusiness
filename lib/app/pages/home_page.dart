import 'package:app/app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  //List<Produto> produtos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(),
      drawer: MeuDrawer(),
      body: BotoesUtilitarios(context),
    );
  }

  Column BotoesUtilitarios(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _searchField(),
        SizedBox(height: 20),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Utilitários',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
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
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                        child: Icon(Icons.fastfood),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20),
                          backgroundColor: Color(0xffD44B4B),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      Text(
                        'Cadastrar\n   Pratos',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            },
                            child: Icon(Icons.food_bank),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(20),
                              backgroundColor: Color(0xffD44B4B),
                              foregroundColor: Colors.white,
                            ),
                          ),
                          Text('Cadastrar\n Produtos',
                              style: TextStyle(fontFamily: 'Poppins')),
                        ],
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

  Widget _searchField() {
    return const SizedBox(
      height: 70,
      child: Padding(
        padding: EdgeInsets.only(top: 30), // distância do AppBar
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(Icons.search),
            ),
            hintText: 'Pesquisar Petiscos...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  AppBar BuildAppBar() {
    return AppBar(
      title: Text(
        'MyFoodBusiness',
        style: TextStyle(
          color: Colors.black87,
          fontFamily: 'Poppins',
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: Builder(
        builder: (context) => GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              'assets/icons/align-left-svgrepo-com.svg',
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
    );
  }
}
