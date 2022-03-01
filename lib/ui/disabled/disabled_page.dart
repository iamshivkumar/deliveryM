import 'package:delivery_m/core/models/profile.dart';
import 'package:delivery_m/ui/components/launch.dart';
import 'package:flutter/material.dart';

class DisabledPage extends StatelessWidget {
  const DisabledPage({Key? key, required this.profile}) : super(key: key);
  final Profile profile;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'You have been disabled!',
              style: style.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Please conatct ${profile.isAdmin ? "support" : "your business owner"} for more information.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            profile.isAdmin
                ? TextButton(
                    onPressed: () {
                      Launch.whatsappSupport(
                        message:
                            "Hello, I am ${profile.firstname} ${profile.lastname}. I have been disabled. Please give me more information about this.",
                      );
                    },
                    child: const Text('Contact Support'),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
