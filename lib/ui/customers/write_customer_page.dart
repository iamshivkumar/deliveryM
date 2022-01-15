import 'dart:io';

import 'package:delivery_m/core/models/address.dart';
import 'package:delivery_m/ui/components/progress_loader.dart';
import 'package:delivery_m/ui/customers/providers/write_customer_view_model.dart';
import 'package:delivery_m/ui/customers/widgets/my_circle_button.dart';
import 'package:delivery_m/ui/pick_address/pick_address_page.dart';
import 'package:delivery_m/ui/pick_address/widgets/picked_address_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class WriteCustomerPage extends ConsumerWidget {
  WriteCustomerPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final model = ref.watch(writeCustomerViewModelProvider);
    return ProgressLoader(
      isLoading: model.loading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Customer'),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: MaterialButton(
            minWidth: double.infinity,
            color: scheme.secondary,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                model.write(onDone: () {
                  Navigator.pop(context);
                });
              }
            },
            child: Text('ADD'),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              TextFormField(
                initialValue: model.name,
                validator: (v) => v!.isEmpty ? "Enter name" : null,
                onSaved: (v) => model.name = v!,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLength: 10,
                keyboardType: TextInputType.number,
                initialValue: model.mobile,
                validator: (v) => v!.isEmpty ? "Enter mobile number" : null,
                onSaved: (v) => model.mobile = v!,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  prefixText: '+91 ',
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
              const SizedBox(height: 16),
              Column(
                children: model.initial.documents
                    .map(
                      (e) => Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 2,
                              child: Image.network(e),
                            ),
                            Positioned(
                              right: 0,
                              child: MyCircleButton(
                                icon: const Icon(Icons.delete),
                                onTap: (){
                                  model.removeDoc(e);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              Column(
                children: model.files
                    .map(
                      (e) => Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 2,
                              child: Image.file(e),
                            ),
                            Positioned(
                              child: MyCircleButton(
                                icon: const Icon(Icons.delete),
                                onTap: (){
                                  model.removeFile(e);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () async {
                  final picked = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    model.addFile(File(picked.path));
                  }
                },
                child: const Text('ADD DOCUMENT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
