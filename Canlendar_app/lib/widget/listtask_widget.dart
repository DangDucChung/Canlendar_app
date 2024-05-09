import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ListTask extends StatelessWidget {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  String? title;
  String? note;
  String? startTime;
  String? endTime;
  String? id;
  final DateTime selectedDate;
  final String userId;
  ListTask({
    Key? key,
    required this.selectedDate,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$selectedDate'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FirebaseAnimatedList(
        query: FirebaseDatabase.instance.reference().child(
            '$userId'), // Thay 'tasks' bằng đường dẫn của bạn trong cơ sở dữ liệu Firebase
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          // Lấy dữ liệu từ snapshot

          Map<dynamic, dynamic>? task = snapshot.value as Map?;
          if (task?['date'] == '$selectedDate') {
            title = task?['title']!;
            note = task?['note']!;
            startTime = task?['startTime']!;
            endTime = task?['endTime']!;
            id = task?['userId']!;
            return GestureDetector(
              onLongPress: () {
                print(id);
                _showBottomSheet(context);
              },
              child: Card(
                elevation: 1,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 26, 102),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$title",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "$note",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Start: $startTime',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'End: $endTime',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            // Nếu không trùng, trả về một widget trống
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
       
        return Container(
          height: 180,
          width: 400,
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _database
                      .child('$userId')
                      .remove(); // Xóa mục trong Firebase

                  Navigator.pop(context);
                  print("Đã Xóa");

                  // Xử lý khi nhấn nút Delete
                },
                style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    backgroundColor: Colors.red // Thêm padding cho nút Close

                    ),
                child: Text(
                  'Delete Task',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Xử lý khi nhấn nút Close
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: 120,
                      vertical: 15), // Thêm padding cho nút Close
                ),
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
