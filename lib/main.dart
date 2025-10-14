import 'package:flutter/material.dart';
import 'app/pages/splash_page.dart';
import 'app/pages/home_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyFoodBusiness',
      theme: AppTheme.light(),     // claro
      darkTheme: AppTheme.dark(),  // escuro (opcional, já pronto)
      themeMode: ThemeMode.system, // SO decide; mude para .light/.dark se quiser fixo
      home: const SplashPage(),
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}
