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