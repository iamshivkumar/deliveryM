import '../../../core/providers/form_key_provider.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddBalanceSheet extends ConsumerWidget {
  const AddBalanceSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final theme = Theme.of(context);
    // final style = theme.textTheme;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final _formKey = ref.watch(formKeyProvider);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autofocus: true,
                decoration: const InputDecoration(prefixText: Labels.rupee),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty
                    ? "Enter amount"
                    : (int.tryParse(v) == null ? "Enter valid amount" : null),
                onSaved: (v) {
                  Navigator.pop(context, double.parse(v!));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                },
                child: const Text('ADD'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
