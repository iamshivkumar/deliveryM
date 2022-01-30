import '../../core/models/address.dart';
import '../pick_address/pick_address_page.dart';
import '../pick_address/widgets/picked_address_card.dart';
import 'providers/register_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegisterPage extends ConsumerWidget {
  RegisterPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(registerViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register your business'),
      ),
      floatingActionButton: model.address != null
          ? FloatingActionButton.extended(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  model.register();
                  Navigator.pop(context);
                }
              },
              label: const Text('CONTINUE'),
            )
          : const SizedBox(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: model.firstname,
                  onSaved: (v) => model.firstname = v!,
                  validator: (v) => v!.isEmpty ? "Enter first name" : null,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: model.lastname,
                  onSaved: (v) => model.lastname = v!,
                  validator: (v) => v!.isEmpty ? "Enter last name" : null,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: model.businessName,
                  onSaved: (v) => model.businessName = v!,
                  validator: (v) => v!.isEmpty ? "Enter business name" : null,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Business Name',
                  ),
                ),
                const SizedBox(height: 16),
                model.address != null
                    ? PickedAddressCard(
                        address: model.address!,
                        onChanged: (v) => model.address = v,
                      )
                    : Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          onTap: () async {
                            final Address? address = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PickAddressPage(),
                              ),
                            );
                            if (address != null) {
                              model.address = address;
                            }
                          },
                          leading: const Icon(Icons.location_pin),
                          title: const Text('Pick Location'),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
