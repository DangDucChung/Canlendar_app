import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/addtask_widget.dart';
import 'package:flutter_application_1/widget/listtask_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_application_1/widget/tasks_widget.dart'; // Thêm import TasksWidget

class CalendarWidget extends StatelessWidget {
  final String userId;

  CalendarWidget({required this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.month,
        initialSelectedDate: DateTime.now(),

        onTap: (CalendarTapDetails details) {
          // Kiểm tra xem người dùng đã chọn ngày hay không
          if (details.targetElement == CalendarElement.calendarCell) {
            print('Selected Date: ${details.date}');
              print('Selected Date: $userId');
            // Điều hướng đến màn hình mới khi ngày được chọn
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ListTask(
                        selectedDate: details.date!,
                        userId: userId
                      )),
            );
          }
        },
        // onLongPress: (details) {
        //   showModalBottomSheet(
        //       context: context, builder: (context) => TaskWidget(details.date!));
        // },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue, // Màu nền xanh cho viền hình tròn
            child: IconButton(
              color: Colors.white, // Màu của icon
              icon: Icon(Icons.show_chart),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => TaskWidget(DateTime.now()),
                );
                // Xử lý sự kiện khi nút icon biểu đồ được nhấn
              },
            ),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTask(userId: userId)),
              );
              print('id:$userId');
            },
            backgroundColor: Colors.blue, // Đặt màu cho nút FAB
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
