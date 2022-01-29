import 'package:delivery_m/utils/formats.dart';
import 'package:equatable/equatable.dart';

class Delivery extends Equatable {
  final String date;
  final int quantity;
  final String status;

  const Delivery({
    required this.date,
    required this.quantity,
    required this.status,
  });

  String get monthDay => Formats.monthDayFromDate(date);

  DateTime get dateTime => Formats.dateTime(date);

  Delivery copyWith({
    String? date,
    int? quantity,
    String? status,
  }) {
    return Delivery(
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'quantity': quantity,
      'status': status,
    };
  }

  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      date: map['date'],
      quantity: map['quantity'],
      status: map['status'],
    );
  }

  @override
  List<Object?> get props => [date];
}

class DeliveryType {
  final String name;
  final int diff;

  DeliveryType(this.name, this.diff);

  static List<DeliveryType> values = [
    DeliveryType('Daily', 1),
    DeliveryType('Alternate Date', 2),
    DeliveryType('Weekly', 7),
  ];
}
