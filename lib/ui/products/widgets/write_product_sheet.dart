import 'package:delivery_m/utils/assets.dart';

import '../../../core/providers/form_key_provider.dart';
import '../providers/write_product_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WriteProductSheet extends ConsumerWidget {
  const WriteProductSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final _formKey = ref.watch(formKeyProvider);
    final model = ref.watch(writeProductViewModelProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottom),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${model.forEdit ? "Edit" : "Add"} Product',
              style: style.headline6,
            ),
            const SizedBox(height: 16),
            Row(
              children: Assets.products
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        model.image = e;
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          border: model.image == e ? Border.all() : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(e),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: model.name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) => v!.isEmpty ? "Enter name" : null,
              onSaved: (v) => model.name = v!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: "${model.price}",
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
              validator: (v) => v!.isEmpty ? "Enter price" : null,
              onSaved: (v) => model.price = double.tryParse(v!) ?? 0,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: model.returnKit,
                  onChanged: (v) => model.returnKit = v!,
                ),
                const Text('Has return kit.')
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  model.write();
                  Navigator.pop(context);
                }
              },
              child: const Text('SAVE'),
            )
          ],
        ),
      ),
    );
  }
}
