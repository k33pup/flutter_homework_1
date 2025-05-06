import 'package:cat_tinder/presentation/cubits/liked_cats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'service_locator.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/liked_cats_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  setupLocator();
  await GetIt.instance<LikedCatsCubit>().init();
  runApp(const MyApp());
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
