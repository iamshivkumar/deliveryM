import 'package:delivery_m/core/repositories/profile_repository_provider.dart';
import 'package:delivery_m/ui/components/error.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/delivery_boys/providers/delivery_boys_provider.dart';
import 'package:delivery_m/ui/pick_address/widgets/picked_address_card.dart';
import 'package:delivery_m/ui/subscriptions/assigned_subscriptions_page.dart';
import 'package:delivery_m/utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeliveryBoyPage extends ConsumerWidget {
  const DeliveryBoyPage({Key? key, required this.dId}) : super(key: key);

  final String dId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(delilveryBoysProvider).when(
          data: (dboys) {
            final dboy = dboys.where((element) => element.id == dId).first;

            final repository = ref.read(profileRepositoryProvider);
            return Scaffold(
              appBar: AppBar(
                title: Text(dboy.name),
                actions: [
                  dboy.active
                      ? const SizedBox()
                      : const Chip(
                          label: Text(
                            Labels.disabled,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.red,
                        ),
                 dboy.isAdmin?const SizedBox(): PopupMenuButton<String>(
                      itemBuilder: (context) => [
                            dboy.active ? Labels.disable : Labels.enable,
                          ]
                              .map(
                                (e) => PopupMenuItem(
                                  child: Text(e),
                                  value: e,
                                ),
                              )
                              .toList(),
                      onSelected: (v) {
                        repository.updateDeliveryBoyStatus(
                          dId: dId,
                          value: v == Labels.enable,
                        );
                      })
                ],
              ),
              body: ListView(
                children: [
                  Card(
                    child: ListTile(
                      title: const Text("Assigned Subscriptions"),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AssignedSubscriptionsPage(
                              dId: dId,
                              dName: dboy.name,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(dboy.mobile),
                      leading: const Icon(Icons.call),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: PickedAddressCard(
                      address: dboy.address,
                      onChanged: (v) {
                        repository.updateAddress(
                          dId: dId,
                          address: v,
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
          error: (e, s) => DataError(e: e),
          loading: () => const Loading(material: true),
        );
  }
}
