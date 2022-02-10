import 'package:delivery_m/ui/auth/providers/auth_provider.dart';
import 'package:delivery_m/ui/auth/verify_page.dart';

import 'ui/auth/providers/user_provider.dart';
import 'ui/components/loading.dart';
import 'ui/home/delivery_boy_home_page.dart';
import 'ui/home/home_page.dart';
import 'ui/order/order_page.dart';
import 'ui/profile/providers/profile_provider.dart';
import 'ui/start/start_page.dart';
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
    final auth = ref.watch(authProvider);
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: userStream.when(
        data: (user) => user == null
            ? Navigator(
                pages: [
                  const MaterialPage(child: LoginPage()),
                  if (auth.verificationId != null)
                    const MaterialPage(child: VerifyPage()),
                ],
                onPopPage: (route, value) {
                  return route.didPop(value);
                },
              )
            : ref.watch(profileProvider).when(
                  data: (profile) => profile != null
                      ? profile.isAdmin
                          ? profile.expired
                              ? const OrderPage()
                              : const HomePage()
                          : DeliveryBoyHomePage(
                              profile: profile,
                            )
                      : const StartPage(),
                  error: (e, s) => DataError(e: e),
                  loading: () => const Loading(),
                ),
        error: (e, s) => DataError(e: e),
        loading: () => const Loading(),
      ),
    );
  }
}

