import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delyman'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please update the app to avail the services.',
                style: theme.textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  launch(
                    'https://play.google.com/store/apps/details?id=com.delyman.app',
                  );
                },
                child: const Text("UPDATE"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
