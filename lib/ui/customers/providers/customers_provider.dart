import 'package:delivery_m/core/models/customer.dart';
import 'package:delivery_m/core/models/product.dart';
import 'package:delivery_m/core/repositories/customers_repository_provider.dart';
import 'package:delivery_m/ui/profile/providers/profile_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final customersProvider = StreamProvider<List<Customer>>(
  (ref) => ref
      .read(customersRepositoryProvider)
      .customersStream(ref.watch(profileProvider).value?.id??''),
);
