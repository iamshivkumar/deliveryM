import 'package:delivery_m/ui/auth/providers/auth_provider.dart';
import 'package:delivery_m/ui/auth/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountDialog extends ConsumerWidget {
  const AccountDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final user = ref.read(userProvider).value!;
    return AlertDialog(
      title: RichText(
        text: TextSpan(
          text: 'Logined with ',
          style: style.headline6!.copyWith(
            color: style.caption!.color,
          ),
          children: [
            TextSpan(
              text: user.phoneNumber,
              style: style.headline6,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('BACK'),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(authProvider).signOut();
            Navigator.pop(context);
          },
          child: const Text('LOGOUT'),
        ),
      ],
    );
  }
}
