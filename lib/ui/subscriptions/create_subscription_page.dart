import 'package:delivery_m/core/models/customer.dart';
import 'package:delivery_m/core/models/delivery.dart';
import 'package:delivery_m/core/models/product.dart';
import 'package:delivery_m/ui/products/providers/products_provider.dart';
import 'package:delivery_m/ui/subscriptions/providers/create_subscription_view_model_provider.dart';
import 'package:delivery_m/ui/subscriptions/widgets/schedule_preview.dart';
import 'package:delivery_m/utils/dates.dart';
import 'package:delivery_m/utils/formats.dart';
import 'package:delivery_m/utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateSubscriptionPage extends HookConsumerWidget {
  const CreateSubscriptionPage({Key? key, required this.customer})
      : super(key: key);
  final Customer customer;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider).asData?.value??[];
    final model = ref.watch(createSubscriptionViewModelProvider(customer.id));
    final startController = useTextEditingController();
    final endController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Subscription'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('CREATE'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
              onChanged: (v) {},
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: startController,
              readOnly: true,
              onTap: () async {
              final picked =  await  showDatePicker(
                  context: context,
                  initialDate: Dates.today,
                  firstDate: Dates.today,
                  lastDate: Dates.today.add(
                    const Duration(days: 30),
                  ),
                );
                if(picked!=null){
                   model.startDate = picked;
                   startController.text = Formats.date(picked);
                   if(model.endDate!=null&&model.endDate!.isBefore(picked)){
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
                
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: endController,
              enabled: model.startDate!=null,
              readOnly:  true,
              decoration: const InputDecoration(
                labelText: 'End Date',
              ),
              onTap: (){
                showDatePicker(
                  context: context,
                  initialDate: model.startDate!.add(const Duration(days: 30)),
                  firstDate: model.startDate!,
                  lastDate: model.startDate!.add(const Duration(days: 30)),
                );
              },
            ),
            const SizedBox(height: 16),
            SchedulePreview(
              dates: List.generate(
                10,
                (index) => Dates.today.add(
                  Duration(days: index * 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
