import 'package:flutter/material.dart';

class TCPage extends StatelessWidget {
  const TCPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(''),
        ),
      ),
    );
  }
}
