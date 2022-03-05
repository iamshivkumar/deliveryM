import 'package:delivery_m/core/models/delivery.dart';

class Dates {
  static DateTime get now => DateTime.now();
  static DateTime get today => DateTime(now.year, now.month, now.day);

  static List<DateTime> generate(
      {required DateTime startDate,
      required DateTime endDate,
      required String type}) {
    final List<DateTime> dates = [];
    late DateTime start;
    if (type==DeliveryType.mondayToSaturady && startDate.weekday == DateTime.sunday) {
      start = startDate.add(const Duration(days: 1));
    } else {
      start = startDate;
    }
    while (start.isBefore(endDate)) {
      dates.add(start);
      if (type!=DeliveryType.mondayToSaturady) {
        start = start.add(
          Duration(
            days: DeliveryType.getDiff(type),
          ),
        );
      } else {
        final next = start.add(const Duration(days: 1));
        if (next.weekday == DateTime.sunday) {
          start = next.add(const Duration(days: 1));
        } else {
          start = next;
        }
      }
    }
    return dates;
  }
}
