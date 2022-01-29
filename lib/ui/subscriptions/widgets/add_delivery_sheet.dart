import 'package:delivery_m/core/enums/delivery_status.dart';
import 'package:delivery_m/core/models/delivery.dart';
import 'package:delivery_m/core/models/subscription.dart';
import 'package:delivery_m/core/providers/form_key_provider.dart';
import 'package:delivery_m/ui/subscriptions/providers/add_delivery_view_model_provider.dart';
import 'package:delivery_m/utils/dates.dart';
import 'package:delivery_m/utils/formats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddDeliverySheet extends HookConsumerWidget {
  AddDeliverySheet({Key? key, required this.subscription}) : super(key: key);
  final Subscription subscription;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final controller = useTextEditingController();
    final statusController = useTextEditingController();
    final model = ref.read(addDeliveryViewModelProvider);
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
                readOnly: true,
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Date",
                ),
                validator: (v) => v!.isEmpty
                    ? "Select date"
                    : (subscription.dates.contains(Formats.date(model.date!))
                        ? "Already Exists"
                        : null),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate:
                        model.date ?? Formats.dateTime(subscription.dates.first),
                    firstDate: Formats.dateTime(subscription.dates.first),
                    lastDate: Formats.dateTime(subscription.dates.last),
                  );
                  if (picked != null) {
                    controller.text = Formats.monthDay(picked);
                    model.date = picked;
                    if (model.date!.isBefore(Dates.today)) {
                      statusController.text = DeliveryStatus.delivered;
                      model.status = DeliveryStatus.delivered;
                    } else {
                      statusController.text = DeliveryStatus.pending;
                      model.status = DeliveryStatus.pending;
                    }
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: model.quantity?.toString(),
                decoration: const InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
                onSaved: (v) => model.quantity = int.parse(v!),
                validator: (v) => v!.isEmpty
                    ? "Enter quantity"
                    : (int.tryParse(v) == null || int.parse(v) < 1
                        ? "Enter valid quantity"
                        : null),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: statusController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Status"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    model.add(subscription);
                    Navigator.pop(context);
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
