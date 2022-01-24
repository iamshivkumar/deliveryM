import 'package:delivery_m/core/models/customer.dart';
import 'package:delivery_m/core/repositories/customers_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final customerProvider = StreamProvider.family<Customer, String>(
  (ref, id) => ref.read(customersRepositoryProvider).customerFuture(id),
);
