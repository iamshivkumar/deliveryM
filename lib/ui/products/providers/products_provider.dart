import '../../../core/models/product.dart';
import '../../../core/repositories/products_repository_provider.dart';
import '../../profile/providers/profile_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final productsProvider = StreamProvider<List<Product>>(
  (ref) => ref.read(productsRepositoryProvider).productsStream(
        ref.watch(profileProvider).value!.eId,
      ),
);
