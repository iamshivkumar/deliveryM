import 'package:delivery_m/ui/customers/providers/customers_provider.dart';
import 'package:delivery_m/utils/dates.dart';

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
  bool get manage => _manage ?? _product?.returnKit ?? false;
  set manage(bool manage) {
    _manage = manage;
    notifyListeners();
  }

  bool _recure = true;
  bool get recure => _recure;
  set recure(bool recure) {
    _recure = recure;
    notifyListeners();
  }

  String? dId;

  int quantity = 1;

  List<DateTime> get dates {
    if (startDate == null || endDate == null) {
      return [];
    } else {
      return Dates.generate(
        startDate: startDate!,
        endDate: endDate!,
        type: deliveryType.name,
      );
    }
  }

  void create() {
    final subscription = Subscription(
      id: '',
      dId: dId!,
      key: _ref
          .read(customersProvider)
          .value!
          .where((element) => element.id == cId)
          .first
          .name
          .substring(0, 2)
          .toLowerCase(),
      eId: _profile.id,
      customerId: cId,
      recure: recure,
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
      type: deliveryType.name,
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
