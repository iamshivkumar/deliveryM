import 'package:delivery_m/ui/auth/providers/auth_provider.dart';
import 'package:delivery_m/ui/auth/providers/user_provider.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'ui/auth/login_page.dart';
import 'ui/components/error.dart';

class Root extends ConsumerWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStream = ref.watch(userProvider);
    return userStream.when(
      data: (user) => user == null ? const LoginPage() : const HomePage(),
      error: (e, s) => DataError(e: e),
      loading: () => const Loading(),
    );
  }
}
