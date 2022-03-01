import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionDialog extends StatelessWidget {
  const VersionDialog({Key? key, required this.forced}) : super(key: key);
  final bool forced;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async=>!forced,
      child: AlertDialog(
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
            onPressed: () {
              launch('https://play.google.com/store/apps/details?id=com.delyman.app');
            },
            child: const Text("UPDATE"),
          ),
        ],
      ),
    );
  }
}
