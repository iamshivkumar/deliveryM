import 'package:cloud_firestore/cloud_firestore.dart';
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
    _firestore.collection(Constants.subscriptions).doc(subscription.id).update({
      Constants.deliveries:
          subscription.deliveries.map((e) => e.toMap()).toList()
    });
  }
}
