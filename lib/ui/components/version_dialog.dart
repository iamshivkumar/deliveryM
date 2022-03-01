import 'package:flutter/material.dart';

class VersionDialog extends StatelessWidget {
  const VersionDialog({Key? key, required this.forced}) : super(key: key);
  final bool forced;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Latest version of the app available on playstore.',
      ),
      content: const Text(
        'Please update your app for new features.',
      ),
      actions: [
        forced
            ? const SizedBox()
            : TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("LATER"),
              ),
        ElevatedButton(
          onPressed: () {},
          child: const Text("UPDATE"),
        ),
      ],
    );
  }
}
