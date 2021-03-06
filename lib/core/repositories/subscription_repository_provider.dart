import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_m/ui/customers/providers/customer_provider.dart';
import 'package:delivery_m/utils/dates.dart';
import '../enums/delivery_status.dart';
import '../models/delivery.dart';
import '../models/subscription.dart';
import '../models/wallet_transaction.dart';
import '../../utils/constants.dart';
import '../../utils/formats.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final subscriptionRepositoryProvider =
    Provider<SubscriptionRepository>((ref) => SubscriptionRepository(ref));

class SubscriptionRepository {
  final Ref _ref;
  SubscriptionRepository(this._ref);

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
        .where(Constants.endDate, isGreaterThanOrEqualTo: Dates.today)
        .orderBy(Constants.endDate, descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Subscription.fromFirestore(e),
              )
              .toList(),
        );
  }

  Stream<List<Subscription>> customerInactiveSubscriptionsStream(
      {required String cId, required String eId}) {
    return _firestore
        .collection(Constants.subscriptions)
        .where(Constants.eId, isEqualTo: eId)
        .where(Constants.customerId, isEqualTo: cId)
        .where(Constants.endDate, isLessThan: Dates.today)
        .orderBy(Constants.endDate, descending: true)
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

  void updateActive({required bool value, required String sId}) {
    _firestore
        .collection(Constants.subscriptions)
        .doc(sId)
        .update({Constants.active: value});
  }

  void update({
    required Subscription subscription,
    required Delivery updated,
  }) async {
    final bool isLast =
        subscription.dates.last == updated.date && subscription.recure;
    final initial =
        subscription.deliveries.where((element) => element == updated).first;
    subscription.deliveries[subscription.deliveries.indexOf(updated)] = updated;
    final balance =
        _ref.read(customerProvider(subscription.customerId)).value!.balance;
    final _batch = _firestore.batch();
    _batch.update(
        _firestore.collection(Constants.subscriptions).doc(subscription.id), {
      Constants.recure: isLast ? false : subscription.recure,
      Constants.deliveries:
          subscription.deliveries.map((e) => e.toMap()).toList(),
      Constants.returnKitsQt: subscription.returnKitsQt != null
          ? (initial.status != updated.status
              ? (updated.status == DeliveryStatus.delivered &&
                      initial.status != DeliveryStatus.delivered
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
              Constants.balance: FieldValue.increment(
                  -updated.quantity * subscription.product.price)
            });
        _batch.set(
          _firestore.collection(Constants.walletTransactions).doc(),
          WalletTransaction(
                  id: '',
                  cId: subscription.customerId,
                  sId: subscription.id,
                  dId: subscription.dId,
                  pId: subscription.product.id,
                  date: updated.date,
                  quantity: updated.quantity,
                  amount: -subscription.product.price * updated.quantity,
                  createdAt: DateTime.now(),
                  name: subscription.product.name,
                  balance: balance +
                      (-subscription.product.price * updated.quantity))
              .toMap(),
        );
      } else if (initial.status == DeliveryStatus.delivered &&
          updated.status == DeliveryStatus.canceled) {
        _batch.update(
            _firestore
                .collection(Constants.customers)
                .doc(subscription.customerId),
            {
              Constants.balance: FieldValue.increment(
                  updated.quantity * subscription.product.price)
            });
        _batch.set(
          _firestore.collection(Constants.walletTransactions).doc(),
          WalletTransaction(
            id: '',
            cId: subscription.customerId,
            sId: subscription.id,
            dId: subscription.dId,
            pId: subscription.product.id,
            date: updated.date,
            quantity: -updated.quantity,
            amount: subscription.product.price * updated.quantity,
            createdAt: DateTime.now(),
            name: subscription.product.name,
            balance: balance + (subscription.product.price * updated.quantity),
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
                FieldValue.increment(-quantity * subscription.product.price)
          });
      _batch.set(
        _firestore.collection(Constants.walletTransactions).doc(),
        WalletTransaction(
                id: '',
                pId: subscription.product.id,
                cId: subscription.customerId,
                sId: subscription.id,
                dId: subscription.dId,
                date: updated.date,
                quantity: quantity,
                amount: -subscription.product.price * quantity,
                createdAt: DateTime.now(),
                name: subscription.product.name,
                balance: balance + (-subscription.product.price * quantity))
            .toMap(),
      );
    }
    _batch.commit();
    if (isLast) {
      final duration = subscription.endDate.difference(subscription.startDate);
      var start = subscription.endDate
          .add(Duration(days: DeliveryType.getDiff(subscription.type)));
      final end = start.add(duration);
      final dates = Dates.generate(
        startDate: start,
        endDate: end,
        type: subscription.type,
      );

      final updated = subscription.copyWith(
        returnKitsQt: subscription.returnKitsQt == null ? null : 0,
        dates: dates.map((e) => Formats.date(e)).toList(),
        deliveries: dates
            .map(
              (e) => Delivery(
                date: Formats.date(e),
                quantity: subscription.quantity,
                status: DeliveryStatus.pending,
              ),
            )
            .toList(),
        startDate: start,
        endDate: end,
      );
      _firestore.collection(Constants.subscriptions).add(updated.toMap());
    }
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
    final balance =
        _ref.read(customerProvider(subscription.customerId)).value!.balance;

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
            Constants.balance: FieldValue.increment(
                -delivery.quantity * subscription.product.price)
          });
      _batch.set(
        _firestore.collection(Constants.walletTransactions).doc(),
        WalletTransaction(
          id: '',
          cId: subscription.customerId,
          sId: subscription.id,
          dId: subscription.dId,
          pId: subscription.product.id,
          date: delivery.date,
          quantity: delivery.quantity,
          amount: -subscription.product.price * delivery.quantity,
          createdAt: DateTime.now(),
          name: subscription.product.name,
          balance: balance + (-subscription.product.price * delivery.quantity),
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

  Stream<bool> isSubscriptionExist(String eId) {
    return _firestore
        .collection(Constants.subscriptions)
        .where(Constants.eId, isEqualTo: eId)
        .limit(1)
        .snapshots()
        .map(
          (event) => event.docs.isEmpty ? false : true,
        );
  }

  Future<List<DocumentSnapshot>> walletTransactionsLimitFuture(
      {required int limit, DocumentSnapshot? last, required String cId}) async {
    var collectionRef = _firestore
        .collection(Constants.walletTransactions)
        .where(Constants.cId, isEqualTo: cId)
        .orderBy(Constants.createdAt, descending: true)
        .limit(limit);
    if (last != null) {
      collectionRef = collectionRef.startAfterDocument(last);
    }
    return await collectionRef.get().then(
          (value) => value.docs,
        );
  }
}
