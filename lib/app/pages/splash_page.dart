import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Espera 2 segundos e vai para a Home
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.fastfood, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'MyFoodBusiness',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900, // bem negrito
                fontFamily: 'sans-serif', // nativa
                letterSpacing: 1.5, // um pouco de espaçamento
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
