import 'package:delivery_m/core/repositories/profile_repository_provider.dart';
import 'package:delivery_m/ui/auth/providers/auth_provider.dart';
import 'package:delivery_m/ui/components/error.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/pick_address/widgets/picked_address_card.dart';
import 'package:delivery_m/ui/profile/create_dboy_profile_page.dart';
import 'package:delivery_m/ui/profile/providers/create_deboy_profile_view_model.dart';
import 'package:delivery_m/ui/profile/providers/profile_provider.dart';
import 'package:delivery_m/ui/profile/providers/write_profile_view_model_provider.dart';
import 'package:delivery_m/ui/profile/write_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileStream = ref.watch(profileProvider);
    final repository = ref.read(profileRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: profileStream.when(
        data: (profile) => ListView(
          padding: const EdgeInsets.all(4),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(profile!.name),
                trailing: IconButton(
                  onPressed: () async {
                    final writer = ref.read(writeProfileViewModelProvider);
                    final dWriter =
                        ref.read(createDboyProfileViewModelProvider);
                    if (profile.isAdmin) {
                      writer.initial = profile;
                    } else {
                      dWriter.initial = profile;
                    }
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => profile.isAdmin
                            ? WriteProfilePage()
                            : CreateDboyProfilePage(eId: profile.eId),
                      ),
                    );
                    writer.clear();
                    dWriter.clear();
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.call),
                title: Text(profile.mobile),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: PickedAddressCard(
                address: profile.address,
                onChanged: (v) {
                  repository.updateAddress(dId: profile.id, address: v);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton.icon(
                onPressed: (){
                  ref.read(authProvider).signOut();
                  Navigator.pop(context);
                },
                label: const Text('Logout'),
                icon: const Icon(Icons.logout),
              ),
            ),
          ],
        ),
        error: (e, s) => DataError(e: e),
        loading: () => const Loading(),
      ),
    );
  }
}
