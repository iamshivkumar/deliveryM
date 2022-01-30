import '../../core/repositories/geo_repository_provider.dart';
import '../components/loading.dart';
import 'providers/pick_address_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/searches_provider.dart';

class SearchPage extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          showSuggestions(context);
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchView(onDone: ()=>close(context, null),);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final model = ref.read(searchViewModelProvider);
        if(model.debouncer.value!=query){
          model.debouncer.value = query;
        }
        return SearchView(onDone: ()=>close(context, null),);
      }
    );
  }
}

class SearchView extends ConsumerWidget {
  const SearchView({Key? key, required this.onDone}) : super(key: key);
  final VoidCallback onDone;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searches = ref.watch(searchViewModelProvider);
    final addressModel = ref.read(pickAddressViewModelProvider);
    final repo = ref.read(geoReposioryProvider);
    return ListView(
      padding: const EdgeInsets.all(8),
      children: (searches.loading
          ? [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Loading(),
              )
            ]
          : searches.results
              .map(
                (e) => Column(
                  children: [
                    const Divider(),
                    ListTile(
                      onTap: () async {
                        addressModel.address = await repo.getAddressById(e.id);
                        onDone();
                      },
                      title: Text(e.title),
                      subtitle: Text(e.subtitle),
                    ),
                  ],
                ),
              )
              .toList()),
    );
  }
}
