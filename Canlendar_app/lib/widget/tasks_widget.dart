import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskWidget extends StatefulWidget {
  final DateTime selectedDate;
  final String userId;
  TaskWidget(this.selectedDate, {required this.userId});
  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TaskWidget> {
 

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      body: SfCalendarTheme(
        data: SfCalendarThemeData(),
        child: SfCalendar(
          view: CalendarView.timelineDay,
          
          dataSource: MeetingDataSource(getAppointments()), // Truyền danh sách cuộc hẹn vào dataSource
        ),
      ),
    );
  }

  Future<List<Appointment>> getAppointments() async {
    List<Appointment> meetings = <Appointment>[];
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot =
        await firestore.collection(widget.userId).get(); // Sử dụng userId trong collection()

    // Sử dụng Completer để xử lý Future
   

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      DateTime startTime = data['startTime'].toDate();
      DateTime endTime = data['endTime'].toDate();
      String title = data['title'];
      print('data:$endTime');
      meetings.add(Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: title,
        color: Colors.blue,
      ));
    });
 Completer<List<Appointment>> completer = Completer<List<Appointment>>();
    // Khi tất cả các dữ liệu đã được xử lý, hoàn thành Future và trả về danh sách appointments
    completer.complete(meetings);
    return completer.future;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(Future<List<Appointment>> source) {
    source.then((appointments) {
      this.appointments = appointments;
      notifyListeners(CalendarDataSourceAction.reset, []);
    });
  }
}