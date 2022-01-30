import '../../../core/providers/form_key_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddReturnedKitsQuantitySheet extends ConsumerWidget {
  const AddReturnedKitsQuantitySheet({Key? key, required this.available})
      : super(key: key);
  final int available;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
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
              child: Text(
                "Enter returned kits quantity.",
                style: style.subtitle1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autofocus: true,
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty
                    ? "Enter quantity"
                    : (int.tryParse(v) == null
                        ? "Enter valid quantity"
                        : int.parse(v) > available
                            ? "Not available"
                            : null),
                onSaved: (v) {
                  Navigator.pop(context, int.parse(v!));
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
                child: const Text('SAVE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
