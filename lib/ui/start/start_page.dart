import '../components/error.dart';
import '../components/loading.dart';
import '../profile/create_dboy_profile_page.dart';
import 'providers/businesses_provider.dart';
import 'write_profile_page.dart';
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
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteProfilePage(),
            ),
          );
        },
        label: const Text('Get started'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[] +
              businessesFuture.when(
                  data: (businesses) => businesses
                      .map(
                        (e) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                    child:
                                        const Text('Continue as delivery boy'),
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
              [],
        ),
      ),
    );
  }
}
