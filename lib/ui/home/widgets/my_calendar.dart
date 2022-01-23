import 'package:delivery_m/ui/home/providers/calendar_view_model_provider.dart';
import 'package:delivery_m/utils/dates.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../utils/utils.dart';

class MyCalendar extends ConsumerWidget {
    // ignore: prefer_const_constructors_in_immutables
    MyCalendar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    const calenderStyle = CalendarStyle();
    final model = ref.read(calendarViewModelProvider);
    return Card(
      margin: EdgeInsets.zero,
      child: TableCalendar(
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: scheme.secondary,
            shape: BoxShape.circle,
          ),
          todayTextStyle: calenderStyle.defaultTextStyle,
          todayDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: scheme.secondary, width: 1),
            shape: BoxShape.circle,
          ),
        ),
        selectedDayPredicate: (d) => isSameDay(model.selectedDate, d),
        onDaySelected: (d1, d2) {
          // print(d1);
          model.selectedDate = DateTime(d1.year, d1.month, d1.day);
        },
        onPageChanged: (d2) => model.focusDate = d2,
        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (d, e) => Utils.weekD(d),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        availableCalendarFormats: const {
          CalendarFormat.week: "Week",
        },
        calendarFormat: CalendarFormat.week,
        focusedDay: model.focusDate,
        firstDay: DateTime(2022),
        lastDay: Dates.today.add(const Duration(days: 30)),
      ),
    );
  }
}