import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/calendar_widget.dart';

class MainPage extends StatelessWidget {
  String username = "John Doe"; // Thay "John Doe" bằng tên người dùng thực tế
final String userId;

  MainPage({required this.userId});
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Calendar Events App",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle), // Icon người dùng
              color: Colors.white, // Đặt màu của biểu tượng là màu trắng
              iconSize: 40,
              onPressed: () {
                // Hiển thị tên người dùng và thực hiện chức năng đăng xuất
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text("User Profile"),
                        content: Text(
                            "Username: $username"), // Hiển thị tên người dùng
                        actions: [
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Đóng hộp thoại
                                },
                                child: Text("Close"),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  // Thực hiện chức năng đăng xuất ở đây
                                  // Ví dụ:
                                  // Đặt biến username về giá trị mặc định

                                  Navigator.pop(context); // Đóng hộp thoại
                                },
                                child: Text("Logout"),
                              ),
                            ],
                          )
                        ]);
                  },
                );
              },
            ),
          ],
        ),
        body: CalendarWidget(userId: userId),
      );
}
