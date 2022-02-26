import '../providers/pick_address_view_model_provider.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UpdateAddressSheet extends ConsumerWidget {
  const UpdateAddressSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    final model = ref.read(pickAddressViewModelProvider);
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: model.number,
            decoration: InputDecoration(
              labelText: Labels.houseFlatBlockNo,
            ),
            validator: (v) => v!.isEmpty ? "Required" : null,
            onSaved: (v) => model.number = v!,
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: model.area,
            decoration: const InputDecoration(
              labelText: Labels.area,
            ),
            validator: (v) => v!.isEmpty ? "Required" : null,
            onSaved: (v) => model.area = v!,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: model.city,
            decoration: const InputDecoration(
              labelText: Labels.cityVillage,
            ),
            validator: (v) => v!.isEmpty ? "Required" : null,
            onSaved: (v) => model.city = v!,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              model.pickAddress((p0) {
                Navigator.pop(context);
                Navigator.pop(context, p0);
              });
            },
            child: const Text('Select Address'),
          ),
        ],
      ),
    );
  }
}
