import 'package:delivery_m/ui/components/error.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/delivery_boys/delivery_boy_page.dart';
import 'package:delivery_m/ui/delivery_boys/providers/delivery_boys_provider.dart';
import 'package:delivery_m/ui/profile/providers/profile_provider.dart';
import 'package:delivery_m/utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeliveryBoysPage extends ConsumerWidget {
  const DeliveryBoysPage({Key? key, this.forSelect = false}) : super(key: key);
  final bool forSelect;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final deliveryBoysStream = ref.watch(delilveryBoysProvider);
    final profile = ref.read(profileProvider).value!;
    return Scaffold(
      appBar: AppBar(
        title: Text(forSelect ? "Select delivery boy" : 'Delivery Boys'),
      ),
      body: deliveryBoysStream.when(
        data: (dboys) => ListView(
          padding: const EdgeInsets.all(4),
          children: dboys
              .map(
                (e) => Card(
                  child: ListTile(
                    title: Row(
                      children: [
                        Flexible(child: Text(e.name)),
                        e.id == profile.id
                            ? Text(
                                ' - You ',
                                style: style.subtitle2!.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(width: 8),
                        !e.active
                            ? Material(
                                color: Colors.red,
                                shape: const StadiumBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  child: Text(
                                    Labels.disabled.toUpperCase(),
                                    style: style.overline!.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
                    subtitle: Text(e.address.formated),
                    onTap: () {
                      if (forSelect) {
                        Navigator.pop(context, e.id);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeliveryBoyPage(dId: e.id),
                          ),
                        );
                      }
                    },
                  ),
                ),
              )
              .toList(),
        ),
        error: (e, s) => DataError(e: e),
        loading: () => const Loading(),
      ),
    );
  }
}
