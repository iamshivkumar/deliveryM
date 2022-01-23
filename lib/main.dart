import 'package:delivery_m/root.dart';
import 'package:delivery_m/ui/auth/login_page.dart';
import 'package:delivery_m/ui/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: Colors.white,
        buttonTheme: const ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
        ),
        cardTheme: const CardTheme(
          clipBehavior: Clip.antiAlias,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white))),
        colorScheme: base.colorScheme.copyWith(
          primary: Colors.indigo,
          primaryVariant: Colors.indigo,
          onPrimary: Colors.white,
          secondary: Colors.indigo,
          secondaryVariant: Colors.indigo,
          onSecondary: Colors.white,
        ),
      ),
      home: Root(),
    );
  }
}
