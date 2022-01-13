import 'package:delivery_m/ui/auth/providers/auth_provider.dart';
import 'package:delivery_m/ui/auth/providers/user_provider.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/home/home_page.dart';
import 'package:delivery_m/ui/profile/providers/profile_provider.dart';
import 'package:delivery_m/ui/start/start_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'ui/auth/login_page.dart';
import 'ui/components/error.dart';

class Root extends ConsumerWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userStream = ref.watch(userProvider);

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: userStream.when(
        data: (user) => user == null
            ? const LoginPage()
            : ref.watch(profileProvider).when(
                  data: (profile) => profile != null ? const HomePage() : const StartPage(),
                  error: (e, s) => DataError(e: e),
                  loading: () => const Loading(),
                ),
        error: (e, s) => DataError(e: e),
        loading: () => const Loading(),
      ),
    );
  }
}
