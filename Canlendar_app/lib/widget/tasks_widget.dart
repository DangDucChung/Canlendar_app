import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class TaskWidget extends StatefulWidget {
  final DateTime selectedDate;

  TaskWidget(this.selectedDate);
  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return SfCalendarTheme(
      data: SfCalendarThemeData(),
      child: SfCalendar(
        view: CalendarView.timelineDay,
        initialSelectedDate: widget.selectedDate,
        
      ),
    );
  }
}
