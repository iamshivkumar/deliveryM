import 'package:delivery_m/core/models/product.dart';
import 'package:delivery_m/core/repositories/products_repository_provider.dart';
import 'package:delivery_m/ui/profile/providers/profile_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final productsProvider = StreamProvider<List<Product>>(
  (ref) => ref
      .read(productsRepositoryProvider)
      .productsStream(ref.watch(profileProvider).value?.id??''),
);
