import 'package:flutter/material.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delyman'),
      ),
      body:  Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Please update the app to avail the services.',
            style: theme.textTheme.headline6,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
