import 'package:delivery_m/ui/components/error.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/order/providers/checkout_view_model_provider.dart';
import 'package:delivery_m/ui/order/providers/orders_provider.dart';
import 'package:delivery_m/utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderPage extends ConsumerWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    final ordersStream = ref.watch(ordersProvider);
    return ordersStream.when(
      data: (orders) {
        final bool payable = orders.isEmpty || orders.first.fair;
        return  Scaffold(
                appBar: AppBar(
                  title: Text('Delivery M'),
                  actions: [
                    TextButton(
                        onPressed: () {}, child: Text('Skip to my deliveries'))
                  ],
                ),
                bottomNavigationBar: payable
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: MaterialButton(
                          color: scheme.secondary,
                          padding: const EdgeInsets.all(24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onPressed: () {
                            ref
                                .read(checkoutViewModelProvider)
                                .checkout(amount: 1000);
                          },
                          child: const Text('PAY'),
                        ),
                      )
                    : null,
                body: payable? CheckoutView():Column(),
              );
      },
      error: (e, s) => DataErrorPage(e: e),
      loading: () => const LoadingPage(),
    );
  }
}

class CheckoutView extends StatelessWidget {
  const CheckoutView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 24),
        Text(
          'Pay Subscription Charge',
          style: style.headline6,
        ),
        const SizedBox(height: 16),
        const Text(
          'Pay subscription charge to avail app services for next 31 days.',
        ),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Amount'),
            Text(
              '${Labels.rupee} 1000',
              style: style.headline6,
            ),
          ],
        ),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Duration'),
            Text(
              '31 Days',
              style: style.subtitle1,
            ),
          ],
        ),
      ],
    );
  }
}
