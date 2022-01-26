import 'package:delivery_m/core/enums/delivery_status.dart';
import 'package:delivery_m/core/models/delivery.dart';
import 'package:delivery_m/core/models/product.dart';
import 'package:delivery_m/core/models/profile.dart';
import 'package:delivery_m/core/models/subscription.dart';
import 'package:delivery_m/core/repositories/subscription_repository_provider.dart';
import 'package:delivery_m/ui/profile/providers/profile_provider.dart';
import 'package:delivery_m/utils/formats.dart';
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

  SubscriptionRepository get _repository => _ref.read(subscriptionRepositoryProvider);

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
      productId: _product!.id,
      price: _product!.price,
      startDate: startDate!,
      endDate: endDate!,
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
    );

    try {
      _repository.create(subscription);
    } catch (e) {
      print('$e');
    }
  }
}