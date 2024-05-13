import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/widget/calendar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MainPage extends StatelessWidget {
  
final String userId;
final String? useremail;
  MainPage({required this.userId, required this.useremail});
  Widget build(BuildContext context) => Scaffold(
    
        appBar: AppBar(
          
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          title: const Text("Calendar Events App",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          leading: SizedBox.shrink(),
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
                            "Username: $useremail"), // Hiển thị tên người dùng
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
                                  FirebaseAuth.instance.signOut();
                                
                                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
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
