import 'package:flutter/material.dart';
import 'app/pages/splash_page.dart';
import 'app/pages/home_page.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
      title: 'MyFoodBusiness',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const SplashPage(),
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}