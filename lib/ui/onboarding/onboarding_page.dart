import 'package:delivery_m/ui/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../root.dart';

class OnboardingPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final _controller = useTabController(initialLength: 3);
    _controller.addListener(
      () {
        ref.read(onBoardingIndexProvider.state).state = _controller.index;
      },
    );
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              // context.read(localRepositoryProvider).saveSeen();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            child: Text(
              "SKIP",
              style: TextStyle(color: style.caption!.color),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_controller.index == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Root(),
                  ),
                );
              } else {
                _controller.animateTo(_controller.index + 1);
              }
            },
            child: const Icon(Icons.keyboard_arrow_right_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(''),
                        Text(
                          "",
                          style: style.headline6,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: Consumer(
                builder: (context, ref, child) {
                  final index = ref.watch(onBoardingIndexProvider);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [0, 1, 2]
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: index == e
                                  ? theme.primaryColorLight
                                  : theme.dividerColor,
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final onBoardingIndexProvider = StateProvider<int>((ref) => 0);
