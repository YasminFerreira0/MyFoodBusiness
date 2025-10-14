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
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xffbc5e5e),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Image.asset(
              'assets/images/LogoMFB.png',
              width: constraints.maxWidth,
              height: constraints.maxHeight, 
              fit: BoxFit.contain,
            );
          },
        ),
      ),
    );
  }
}
