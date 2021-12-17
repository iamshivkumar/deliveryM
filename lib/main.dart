import 'package:delivery_m/ui/auth/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: Colors.white,
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
           filled: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
           style: ButtonStyle(
             foregroundColor: MaterialStateProperty.all(Colors.white)
           )
        ),
        colorScheme: base.colorScheme.copyWith(
          primary: Colors.indigo,
          primaryVariant: Colors.white,
          onPrimary: Colors.black,
          secondary: Colors.indigo,
          secondaryVariant: Colors.indigo,
          onSecondary: Colors.white,
        ),
      ),
      home: LoginPage(),
    );
  }
}