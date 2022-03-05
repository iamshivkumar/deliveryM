import 'package:delivery_m/ui/components/launch.dart';
import 'package:delivery_m/ui/components/logo_title.dart';
import 'package:delivery_m/ui/start/widgets/account_dialog.dart';
import 'package:delivery_m/ui/tc/tc_page.dart';
import 'package:delivery_m/utils/labels.dart';

import '../components/error.dart';
import '../components/loading.dart';
import '../profile/create_dboy_profile_page.dart';
import 'providers/businesses_provider.dart';
import '../profile/write_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StartPage extends ConsumerWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final businessesFuture = ref.watch(bussinessesProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const LogoTitle(),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AccountDialog(),
              );
            },
            icon: CircleAvatar(
              child: Icon(
                Icons.person_outline_rounded,
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(4),
        children: <Widget>[] +
            businessesFuture.when(
                data: (businesses) => businesses
                    .map(
                      (e) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  e.businessName!,
                                  style: style.subtitle1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Your mobile number has been added as delivery boy number for this company.',
                                  style: style.caption,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateDboyProfilePage(eId: e.id),
                                      ),
                                    );
                                  },
                                  child: const Text('Continue as delivery boy'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                error: (e, s) => [DataError(e: e)],
                loading: () => [const Loading()]) +
            [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'Manage your daily delivery business.',
                          style: style.headline5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WriteProfilePage(),
                              ),
                            );
                          },
                          child: const Text('Get started'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'Pricing',
                          style: style.headline6,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          '1 Month Free',
                          style: style.headline5!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'Later',
                          style: TextStyle(
                            color: style.caption!.color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          '${Labels.rupee} 499 / Month',
                          style: style.headline5!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'T & C Apply',
                          style: style.caption,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TCPage(),
                    ),
                  );
                },
                child: const Text('Terms & Conditions'),
              ),
              TextButton(
                onPressed: () {
                  Launch.whatsappSupport();
                },
                child: const Text('Need Help?'),
              ),
              TextButton(
                onPressed: () {
                  Launch.whatsappSupport();
                },
                child: const Text('Contact Support'),
              ),
            ],
      ),
    );
  }
}
