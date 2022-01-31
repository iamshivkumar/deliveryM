import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DataError extends StatelessWidget {
  const DataError({Key? key, required this.e}) : super(key: key);
  final Object e;
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(e);
    }
    return Center(
      child: Text(
        "$e",
        textAlign: TextAlign.center,
      ),
    );
  }
}

class DataErrorPage extends StatelessWidget {
  const DataErrorPage({Key? key, required this.e}) : super(key: key);
  final Object e;
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(e);
    }
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          "$e",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
