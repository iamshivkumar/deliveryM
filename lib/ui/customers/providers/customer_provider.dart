import '../../../core/models/customer.dart';
import '../../../core/repositories/customers_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final customerProvider = StreamProvider.family<Customer, String>(
  (ref, id) => ref.read(customersRepositoryProvider).customerFuture(id),
);
