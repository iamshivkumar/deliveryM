import 'package:flutter/material.dart';

class DataError extends StatelessWidget {
  const DataError({Key? key, required this.e}) : super(key: key);
  final Object e;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "$e",
        textAlign: TextAlign.center,
      ),
    );
  }
}
