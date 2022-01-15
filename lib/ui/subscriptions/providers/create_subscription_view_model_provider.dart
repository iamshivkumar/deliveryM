import 'package:delivery_m/core/models/delivery.dart';
import 'package:delivery_m/core/models/product.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final createSubscriptionViewModelProvider = ChangeNotifierProvider.family<CreateSubscriptionViewModel,String>(
  (ref, cId) => CreateSubscriptionViewModel(ref,cId),
);

class CreateSubscriptionViewModel extends ChangeNotifier {
  final Ref ref;
  final String cId;
  CreateSubscriptionViewModel(this.ref, this.cId);


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



  

}
