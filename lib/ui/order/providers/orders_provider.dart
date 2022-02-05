import 'package:delivery_m/core/models/order.dart';
import 'package:delivery_m/core/repositories/order_repository_provider.dart';
import 'package:delivery_m/ui/auth/providers/user_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final ordersProvider = StreamProvider<List<Order>>(
  (ref) => ref
      .read(orderRepositoryProvider)
      .ordersStream(ref.watch(userProvider).value!.uid),
);
