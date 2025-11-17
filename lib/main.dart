import 'package:app/views/pages/home_page.dart';
import 'package:app/views/pages/splash_page.dart';
import 'package:flutter/material.dart';
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
      theme: AppTheme.light(),    
      darkTheme: AppTheme.dark(),  
      themeMode: ThemeMode.system, 
      home: const SplashPage(),
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}
