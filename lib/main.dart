import 'package:flutter/material.dart';
import 'service_locator.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/liked_cats_screen.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кототиндер',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/liked': (context) => LikedCatsScreen(),
      },
    );
  }
}
