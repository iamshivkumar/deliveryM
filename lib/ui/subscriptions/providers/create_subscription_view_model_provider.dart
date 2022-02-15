import '../../../core/enums/delivery_status.dart';
import '../../../core/models/delivery.dart';
import '../../../core/models/product.dart';
import '../../../core/models/profile.dart';
import '../../../core/models/subscription.dart';
import '../../../core/repositories/subscription_repository_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../utils/formats.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final createSubscriptionViewModelProvider =
    ChangeNotifierProvider.family<CreateSubscriptionViewModel, String>(
  (ref, cId) => CreateSubscriptionViewModel(ref, cId),
);

class CreateSubscriptionViewModel extends ChangeNotifier {
  final Ref _ref;
  final String cId;
  CreateSubscriptionViewModel(this._ref, this.cId);

  SubscriptionRepository get _repository =>
      _ref.read(subscriptionRepositoryProvider);

  Profile get _profile => _ref.read(profileProvider).value!;

  Product? _product;
  Product? get product => _product;
  set product(Product? product) {
    _product = product;
    notifyListeners();
  }

  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  set startDate(DateTime? startDate) {
    _startDate = startDate;
    notifyListeners();
  }

  DateTime? _endDate;
  DateTime? get endDate => _endDate;
  set endDate(DateTime? endDate) {
    _endDate = endDate;
    notifyListeners();
  }

  DeliveryType _deliveryType = DeliveryType.values.first;
  DeliveryType get deliveryType => _deliveryType;
  set deliveryType(DeliveryType deliveryType) {
    _deliveryType = deliveryType;
    notifyListeners();
  }

  bool? _manage;
  bool get manage => _manage??_product?.returnKit??false;
  set manage(bool manage) {
    _manage = manage;
    notifyListeners();
  }

  String? dId;

  int quantity = 1;

  List<DateTime> get dates {
    if (startDate == null || endDate == null) {
      return [];
    } else {
      final List<DateTime> dates = [];
      var start = startDate!;
      while (start.isBefore(endDate!)) {
        dates.add(start);
        start = start.add(
          Duration(
            days: deliveryType.diff,
          ),
        );
      }
      return dates;
    }
  }

  void create() {
    final subscription = Subscription(
      id: '',
      dId: dId!,
      eId: _profile.id,
      customerId: cId,
      recure: true,
      active: true,
      product: product!,
      quantity: quantity,
      startDate: startDate!,
      endDate: endDate!,
      returnKitsQt: manage ? 0 : null,
      dates: dates.map((e) => Formats.date(e)).toList(),
      deliveries: dates
          .map(
            (e) => Delivery(
              date: Formats.date(e),
              quantity: quantity,
              status: DeliveryStatus.pending,
            ),
          )
          .toList(),
      diff: deliveryType.diff,
    );

    try {
      _repository.create(subscription);
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }
}
