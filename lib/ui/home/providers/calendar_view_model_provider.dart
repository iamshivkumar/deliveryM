import '../../../utils/dates.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final calendarViewModelProvider = ChangeNotifierProvider(
  (ref) => CalendarViewModel(),
);

class CalendarViewModel extends ChangeNotifier {
  DateTime _selectedDate = Dates.today;
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime selectedDate) {
    _selectedDate = selectedDate;
    notifyListeners();
  }

  DateTime _focusDate = Dates.today;
  DateTime get focusDate => _focusDate;
  set focusDate(DateTime focusDate) {
    _focusDate = focusDate;
    notifyListeners();
  }
}
