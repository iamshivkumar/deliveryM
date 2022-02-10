import 'package:delivery_m/core/enums/payment_status.dart';
import 'package:delivery_m/core/models/order.dart';
import 'package:delivery_m/ui/components/error.dart';
import 'package:delivery_m/ui/components/loading.dart';
import 'package:delivery_m/ui/order/providers/checkout_view_model_provider.dart';
import 'package:delivery_m/ui/order/providers/orders_provider.dart';
import 'package:delivery_m/utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        return Scaffold(
          appBar: AppBar(
            title: Text('Delivery M'),
            actions: [
              TextButton(onPressed: () {}, child: const Text('Skip to my deliveries'))
            ],
          ),
          bottomNavigationBar: payable ||
                  orders.first.paymentStatus == PaymentStatus.failed
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: MaterialButton(
                    color: scheme.secondary,
                    padding: const EdgeInsets.all(24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onPressed: () {
                      ref.read(checkoutViewModelProvider).checkout(
                          amount: 1000,
                          orderId: orders.isNotEmpty ? orders.first.id : null);
                    },
                    child: const Text('PAY'),
                  ),
                )
              : null,
          body: payable ? const CheckoutView() : OrderView(order: orders.first),
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
            const Text('Duration'),
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

class OrderView extends StatelessWidget {
  const OrderView({Key? key, required this.order}) : super(key: key);

  final Order order;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: (order.paymentStatus == PaymentStatus.failed
              ? [
                  const SizedBox(height: 24),
                  Text(
                    'Your payment ${order.paymentStatus}.',
                    style: style.headline6,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Don\'t worry! If your amount deducted, contact support, else try to pay again.',
                  ),
                ]
              : (order.paymentStatus == PaymentStatus.processing
                  ? [
                      const SizedBox(height: 24),
                      Text(
                        'Your payment ${order.paymentStatus}.',
                        style: style.headline6,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Please wait a while, if don\'t see any update, please contact support',
                      ),
                    ]
                  : [
                      const SizedBox(height: 24),
                      Text(
                        'Your payment succeed',
                        style: style.headline6,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'You will get access to services soon. If not please contact support.',
                      ),
                    ])) +
          [
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
                const Text('Duration'),
                Text(
                  '31 Days',
                  style: style.subtitle1,
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order ID'),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: order.id));
                  },
                  child: Row(
                    children: [
                      Text(
                        order.id,
                        style: style.subtitle1,
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.copy, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            order.paymentId != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Payment ID'),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: order.paymentId));
                        },
                        child: Row(
                          children: [
                            Text(
                              order.paymentId!,
                              style: style.subtitle1,
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.copy, size: 16),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(
              height: 32,
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Need Help?'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Contact Support'),
            ),
          ],
    );
  }
}
