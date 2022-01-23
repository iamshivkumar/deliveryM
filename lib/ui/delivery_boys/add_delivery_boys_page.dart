import 'package:delivery_m/core/repositories/profile_repository_provider.dart';
import 'package:delivery_m/ui/components/error.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/profile/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddDeliveryBoysPage extends HookConsumerWidget {
  AddDeliveryBoysPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final controller = useTextEditingController();

    final profileStream = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add delivery boy mobile number'),
      ),
      body: Column(
        children: [
          Material(
            elevation: 2,
            color: theme.cardColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: controller,
                        decoration: InputDecoration(prefixText: '+91 '),
                        validator: (v) => v!.isEmpty
                            ? "Enter mobile number"
                            : v.length < 10
                                ? "Enter valid mobile number"
                                : null,
                        maxLength: 10,
                      ),
                    ),
                    SizedBox(width: 16),
                    SizedBox(
                      height: 48,
                      width: 48,
                      child: MaterialButton(
                        padding: EdgeInsets.zero,
                        minWidth: 0,
                        shape: CircleBorder(),
                        color: scheme.secondary,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ref.read(profileRepositoryProvider)
                                .addDeliveryBoy('+91${controller.text}');
                            controller.clear();
                          }
                        },
                        child: Icon(Icons.add),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: profileStream.when(
            data: (profile) => ListView(
              padding: EdgeInsets.all(4),
              children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                      child: Text('Pending Sign Ups'),
                    ),
                  ] +
                  profile!.deboys!
                      .map(
                        (e) => Card(
                          child: ListTile(
                            title: Text(e),
                          ),
                        ),
                      )
                      .toList(),
            ),
            error: (e, s) => DataError(e: e),
            loading: () => Loading(),
          )),
        ],
      ),
    );
  }
}
