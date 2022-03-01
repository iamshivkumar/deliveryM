import '../../core/models/customer.dart';
import '../../core/models/delivery.dart';
import '../../core/models/product.dart';
import '../products/providers/products_provider.dart';
import 'providers/create_subscription_view_model_provider.dart';
import '../delivery_boys/providers/delivery_boys_provider.dart';
import 'widgets/schedule_preview.dart';
import '../../utils/dates.dart';
import '../../utils/formats.dart';
import '../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateSubscriptionPage extends HookConsumerWidget {
  CreateSubscriptionPage({Key? key, required this.customer}) : super(key: key);
  final Customer customer;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider).asData?.value ?? [];
    final model = ref.watch(createSubscriptionViewModelProvider(customer.id));
    final startController = useTextEditingController();
    final endController = useTextEditingController();
    final dboys = ref.watch(delilveryBoysProvider).asData?.value ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Subscription'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              model.create();
              Navigator.pop(context);
            }
          },
          child: const Text('CREATE'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  title: Text(customer.name),
                  subtitle: Text(customer.address.formated),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Product>(
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Product',
                ),
                value: model.product,
                validator: (v) => v == null ? "Select product" : null,
                items: products
                    .map(
                      (e) => DropdownMenuItem<Product>(
                        child: Row(
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset(e.image),
                            ),
                            const SizedBox(width: 16),
                            Text(e.name),
                            const Spacer(),
                            Text('${Labels.rupee}${e.price}')
                          ],
                        ),
                        value: e,
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  model.product = v;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: startController,
                readOnly: true,
                validator: (v) => v!.isEmpty ? "Select start date" : null,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: Dates.today,
                    firstDate: Dates.today,
                    lastDate: Dates.today.add(
                      const Duration(days: 30),
                    ),
                  );
                  if (picked != null) {
                    model.startDate = picked;
                    startController.text = Formats.monthDay(picked);
                    if (model.endDate != null &&
                        model.endDate!.isBefore(picked)) {
                      endController.text = '';
                      model.endDate = null;
                    }
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<DeliveryType>(
                decoration: const InputDecoration(
                  labelText: "Type",
                ),
                value: model.deliveryType,
                items: DeliveryType.values
                    .map(
                      (e) => DropdownMenuItem<DeliveryType>(
                        child: Text(e.name),
                        value: e,
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  model.deliveryType = v!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: endController,
                enabled: model.startDate != null,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'End Date',
                ),
                validator: (v) => v!.isEmpty ? "Select end date" : null,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: model.startDate!.add(const Duration(days: 30)),
                    firstDate: model.startDate!,
                    lastDate: model.startDate!.add(const Duration(days: 30)),
                  );
                  if (picked != null) {
                    model.endDate = picked;
                    endController.text = Formats.monthDay(picked);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: '${model.quantity}',
                validator: (v) => v!.isEmpty ? "Enter quantity" : null,
                onSaved: (v) => model.quantity = int.parse(v!),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                ),
              ),
              const SizedBox(height: 16),
              SchedulePreview(
                dates: model.dates,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Delivery Boy",
                ),
                isExpanded: true,
                value: model.dId,
                selectedItemBuilder: (BuildContext context) {
                  return dboys.map<Widget>((e) {
                    return Text(e.name);
                  }).toList();
                },
                validator: (v) => v==null ? "Select delivery boy" : null,
                items: dboys
                    .map(
                      (e) => DropdownMenuItem<String>(
                        child: ListTile(
                          dense: true,
                          title: Text(e.name),
                          subtitle: Text(e.address.formated),
                        ),
                        value: e.id,
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  model.dId = v!;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Checkbox(
                  value: model.manage,
                  onChanged: (v) {
                    model.manage = v!;
                  },
                ),
                title: const Text('Manage return kits.'),
              ),
              ListTile(
                leading: Checkbox(
                  value: model.recure,
                  onChanged: (v) {
                    model.recure = v!;
                  },
                ),
                title: const Text(
                    'Automatically create the same subscription after the end date.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
