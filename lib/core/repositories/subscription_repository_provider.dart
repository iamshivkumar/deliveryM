import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_m/core/enums/delivery_status.dart';
import 'package:delivery_m/core/models/delivery.dart';
import 'package:delivery_m/core/models/subscription.dart';
import 'package:delivery_m/utils/constants.dart';
import 'package:delivery_m/utils/formats.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final subscriptionRepositoryProvider =
    Provider<SubscriptionRepository>((ref) => SubscriptionRepository());

class SubscriptionRepository {
  final _firestore = FirebaseFirestore.instance;

  void create(Subscription subscription) {
    _firestore.collection(Constants.subscriptions).add(
          subscription.toMap(),
        );
  }

  Stream<List<Subscription>> customerSubscriptionsStream(
      {required String cId, required String eId}) {
    return _firestore
        .collection(Constants.subscriptions)
        .where(Constants.eId, isEqualTo: eId)
        .where(Constants.customerId, isEqualTo: cId)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Subscription.fromFirestore(e),
              )
              .toList(),
        );
  }

  Stream<List<Subscription>> daySubscriptionsStream(
      {required String eId, required DateTime date}) {
    return _firestore
        .collection(Constants.subscriptions)
        .where(Constants.eId, isEqualTo: eId)
        .where(Constants.active, isEqualTo: true)
        .where(Constants.dates, arrayContains: Formats.date(date))
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Subscription.fromFirestore(e),
              )
              .toList(),
        );
  }

  Stream<List<Subscription>> dboyDaySubscriptionsStream(
      {required String dId, required DateTime date}) {
    return _firestore
        .collection(Constants.subscriptions)
        .where(Constants.dId, isEqualTo: dId)
        .where(Constants.active, isEqualTo: true)
        .where(Constants.dates, arrayContains: Formats.date(date))
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Subscription.fromFirestore(e),
              )
              .toList(),
        );
  }

  void update({required Subscription subscription, required Delivery updated}) {
    final initial =
        subscription.deliveries.where((element) => element == updated).first;
    subscription.deliveries[subscription.deliveries.indexOf(updated)] = updated;

    final _batch = _firestore.batch();
    _batch.update(
        _firestore.collection(Constants.subscriptions).doc(subscription.id), {
      Constants.deliveries:
          subscription.deliveries.map((e) => e.toMap()).toList(),
      Constants.returnKitsQt: subscription.returnKitsQt != null
          ? (initial.status != updated.status
              ? (updated.status == DeliveryStatus.delivered
                  ? FieldValue.increment(updated.quantity)
                  : (initial.status == DeliveryStatus.delivered &&
                          updated.status == DeliveryStatus.canceled
                      ? FieldValue.increment(-updated.quantity)
                      : FieldValue.increment(0)))
              : (initial.status == DeliveryStatus.delivered &&
                      updated.status == DeliveryStatus.delivered
                  ? FieldValue.increment(updated.quantity - initial.quantity)
                  : FieldValue.increment(0)))
          : null
    });
    if (initial.status != updated.status) {
      if (updated.status == DeliveryStatus.delivered) {
        _batch.update(
            _firestore
                .collection(Constants.customers)
                .doc(subscription.customerId),
            {
              Constants.balance:
                  FieldValue.increment(-updated.quantity * subscription.price)
            });
      } else if (initial.status == DeliveryStatus.delivered &&
          updated.status == DeliveryStatus.canceled) {
        _batch.update(
            _firestore
                .collection(Constants.customers)
                .doc(subscription.customerId),
            {
              Constants.balance:
                  FieldValue.increment(updated.quantity * subscription.price)
            });
      }
    } else if (initial.status == DeliveryStatus.delivered &&
        updated.status == DeliveryStatus.delivered) {
      final quantity = updated.quantity - initial.quantity;
      _batch.update(
          _firestore
              .collection(Constants.customers)
              .doc(subscription.customerId),
          {
            Constants.balance:
                FieldValue.increment(-quantity * subscription.price)
          });
    }
    _batch.commit();
  }

  void returnKitsQuantity({required String sId, required int qt}){
     _firestore.collection(Constants.subscriptions).doc(sId).update({
       Constants.returnKitsQt: FieldValue.increment(-qt),
     });
  }
}
