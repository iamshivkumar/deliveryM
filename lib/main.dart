import 'package:delivery_m/ui/colors.dart';
import 'package:delivery_m/ui/order/waiting_page.dart';
import 'package:flutter/services.dart';

import 'root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final base = ThemeData.light();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.blueGrey.shade100));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delyman',
      theme: ThemeData(
        primarySwatch: Palette.swatch,
        scaffoldBackgroundColor: Palette.background,
        buttonTheme: const ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
        ),
        cardTheme: CardTheme(
          clipBehavior: Clip.antiAlias,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Palette.secondary),
            backgroundColor: MaterialStateProperty.all(Palette.primaryDark),
            shape: MaterialStateProperty.all(
              ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ),
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Palette.swatch).copyWith(
          secondary: Palette.secondary,
          secondaryContainer: Palette.secondary,
          onSecondary: Palette.primaryDark,
        ),
      ),
      home: const Root(),
    );
  }
}
