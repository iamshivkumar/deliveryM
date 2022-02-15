import 'package:delivery_m/utils/formats.dart';

import '../providers/calendar_view_model_provider.dart';
import '../../../utils/dates.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCalendar extends ConsumerWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyCalendar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final style = theme.textTheme.apply(
      bodyColor: scheme.onPrimary,
      displayColor: theme.cardColor.withOpacity(0.6),
    );

    final model = ref.read(calendarViewModelProvider);
    return Card(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      margin: EdgeInsets.zero,
      color: theme.primaryColor,
      child: TableCalendar(
        calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: scheme.secondary,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: theme.textTheme.bodyText1!,
            todayTextStyle: style.bodyText1!,
            todayDecoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: scheme.secondary, width: 1),
              shape: BoxShape.circle,
            ),
            outsideTextStyle:
                style.bodyText2!.copyWith(color: style.caption!.color),
            weekendTextStyle:
                style.bodyText2!.copyWith(color: style.caption!.color),
            defaultTextStyle: style.bodyText1!,
            disabledTextStyle:
                style.bodyText2!.copyWith(color: style.caption!.color),
            holidayTextStyle: style.bodyText1!),
        selectedDayPredicate: (d) => isSameDay(model.selectedDate, d),
        onDaySelected: (d1, d2) {
          model.selectedDate = DateTime(d1.year, d1.month, d1.day);
        },
        onPageChanged: (d2) => model.focusDate = d2,
        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (d, e) => Formats.weekD(d),
          weekdayStyle: style.bodyText2!,
          weekendStyle: style.bodyText2!.copyWith(color: style.caption!.color),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: style.subtitle1!,
          leftChevronIcon: Icon(
            Icons.keyboard_arrow_left,
            color: scheme.onPrimary,
          ),
          rightChevronIcon: Icon(
            Icons.keyboard_arrow_right,
            color: scheme.onPrimary,
          ),
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
