import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key, this.material = false}) : super(key: key);
  final bool material;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: material ? null : Colors.transparent,
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
