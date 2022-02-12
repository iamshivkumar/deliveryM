import 'package:intl/intl.dart';

class Formats {
  static String monthDay(DateTime date) =>
      DateFormat(DateFormat.MONTH_DAY).format(date);

    static String monthDayTime(DateTime date) =>
      DateFormat( "MMM d hh:mm a").format(date);
      
  static String date(DateTime date) => DateFormat("dd-MM-yyyy").format(date);
  static String month(DateTime date) => DateFormat(DateFormat.YEAR_MONTH).format(date);

  static String monthDayFromDate(String date) => monthDay(dateTime(date));

  static DateTime dateTime(String date) => DateFormat("dd-MM-yyyy").parse(date);

  static String weekD(DateTime dateTime) {
    return DateFormat(DateFormat.WEEKDAY).format(dateTime).split('').first;
  }
}
