import 'package:intl/intl.dart';

class Formats {
  static String monthDay(DateTime date) =>
      DateFormat(DateFormat.MONTH_DAY).format(date);

  static String date(DateTime date) => DateFormat("dd-MM-yyyy").format(date);
}
