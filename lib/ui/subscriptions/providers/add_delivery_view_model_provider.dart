import '../../../core/models/delivery.dart';
import '../../../core/models/subscription.dart';
import '../../../core/repositories/subscription_repository_provider.dart';
import '../../../utils/formats.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final addDeliveryViewModelProvider =
    Provider((ref) => AddDeliveryViewModelProvider(ref));

class AddDeliveryViewModelProvider {
  final Ref ref;

  DateTime? date;

  int? quantity;
  String? status;

  AddDeliveryViewModelProvider(this.ref);

  void add(Subscription subscription) {
    final updated = Delivery(
        date: Formats.date(date!), quantity: quantity!, status: status!);
    ref
        .read(subscriptionRepositoryProvider)
        .addDelivery(subscription: subscription, delivery: updated);
  }

  void clear() {
    date = null;
    quantity = null;
    status = null;
  }
}
