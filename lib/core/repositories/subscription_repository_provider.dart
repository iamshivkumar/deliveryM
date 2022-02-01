import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/delivery_status.dart';
import '../models/delivery.dart';
import '../models/subscription.dart';
import '../models/wallet_transaction.dart';
import '../../utils/constants.dart';
import '../../utils/formats.dart';
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

  void update(
      {required Subscription subscription, required Delivery updated}) async {
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
        _batch.set(
          _firestore.collection(Constants.walletTransactions).doc(),
          WalletTransaction(
            id: '',
            cId: subscription.customerId,
            sId: subscription.id,
            dId: subscription.dId,
            pId: subscription.productId,
            date: updated.date,
            quantity: updated.quantity,
            amount: -subscription.price * updated.quantity,
            createdAt: DateTime.now(),
            name: subscription.name,
          ).toMap(),
        );
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
        _batch.set(
          _firestore.collection(Constants.walletTransactions).doc(),
          WalletTransaction(
            id: '',
            cId: subscription.customerId,
            sId: subscription.id,
            dId: subscription.dId,
            pId: subscription.productId,
            date: updated.date,
            quantity: -updated.quantity,
            amount: subscription.price * updated.quantity,
            createdAt: DateTime.now(),
            name: subscription.name,
          ).toMap(),
        );
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
      _batch.set(
        _firestore.collection(Constants.walletTransactions).doc(),
        WalletTransaction(
          id: '',
          pId: subscription.productId,
          cId: subscription.customerId,
          sId: subscription.id,
          dId: subscription.dId,
          date: updated.date,
          quantity: quantity,
          amount: -subscription.price * quantity,
          createdAt: DateTime.now(),
          name: subscription.name,
        ).toMap(),
      );
    }
    _batch.commit();
  }

  void returnKitsQuantity({required String sId, required int qt}) {
    _firestore.collection(Constants.subscriptions).doc(sId).update({
      Constants.returnKitsQt: FieldValue.increment(-qt),
    });
  }

  void deleteDelivery({required String sId, required Delivery delivery}) {
    _firestore.collection(Constants.subscriptions).doc(sId).update({
      Constants.deliveries: FieldValue.arrayRemove([delivery.toMap()]),
      Constants.dates: FieldValue.arrayRemove([delivery.date])
    });
  }

  void addDelivery(
      {required Subscription subscription, required Delivery delivery}) async {
    subscription.deliveries.add(delivery);

    subscription.dates.add(delivery.date);

    subscription.deliveries.sort(
        (a, b) => Formats.dateTime(a.date).compareTo(Formats.dateTime(b.date)));

    subscription.dates
        .sort((a, b) => Formats.dateTime(a).compareTo(Formats.dateTime(b)));

    final _batch = _firestore.batch();
    _batch.update(
        _firestore.collection(Constants.subscriptions).doc(subscription.id), {
      Constants.deliveries:
          subscription.deliveries.map((e) => e.toMap()).toList(),
      Constants.dates: subscription.dates,
      Constants.returnKitsQt: subscription.returnKitsQt != null
          ? FieldValue.increment(delivery.status == DeliveryStatus.delivered
              ? delivery.quantity
              : 0)
          : null,
    });

    if (delivery.status == DeliveryStatus.delivered) {
      _batch.update(
          _firestore
              .collection(Constants.customers)
              .doc(subscription.customerId),
          {
            Constants.balance:
                FieldValue.increment(-delivery.quantity * subscription.price)
          });
      _batch.set(
        _firestore.collection(Constants.walletTransactions).doc(),
        WalletTransaction(
          id: '',
          cId: subscription.customerId,
          sId: subscription.id,
          dId: subscription.dId,
          pId: subscription.productId,
          date: delivery.date,
          quantity: delivery.quantity,
          amount: -subscription.price * delivery.quantity,
          createdAt: DateTime.now(),
          name: subscription.name,
        ).toMap(),
      );
    }
    _batch.commit();
  }

  void changeDboy({required String sId, required String dId}) {
    _firestore.collection(Constants.subscriptions).doc(sId).update({
      Constants.dId: dId,
    });
  }

  Stream<List<Subscription>> dboyMonthSubscriptionsStream(
      {required String dId, required DateTime month}) {
    return _firestore
        .collection(Constants.subscriptions)
        .where(Constants.dId, isEqualTo: dId)
        .where(
          Constants.startDate,
          isGreaterThanOrEqualTo: month,
          isLessThanOrEqualTo: DateTime(month.year, month.month + 1, 0),
        )
        .orderBy(Constants.startDate)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Subscription.fromFirestore(e)).toList());
  }

  Stream<Subscription> subscriptionStream(String sId) {
    return _firestore
        .collection(Constants.subscriptions)
        .doc(sId)
        .snapshots()
        .map(
          (event) => Subscription.fromFirestore(event),
        );
  }

  Stream<List<WalletTransaction>> transactionsStream(String sId) {
    return _firestore
        .collection(Constants.walletTransactions)
        .where(Constants.sId, isEqualTo: sId)
        .orderBy(Constants.createdAt)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => WalletTransaction.fromMap(e),
              )
              .toList(),
        );
  }
}
