import 'package:intl/intl.dart';

class Formats {
  static String date(DateTime date) =>
      DateFormat(DateFormat.MONTH_DAY).format(date);
}
