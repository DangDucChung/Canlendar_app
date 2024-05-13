import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/widget/updatetask_widget.dart';
import 'package:intl/intl.dart';

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
        title: Text(DateFormat.yMMMd().format(selectedDate),style: TextStyle(color: const Color.fromARGB(255, 13, 13, 13)) ),
        backgroundColor: Color.fromARGB(255, 86, 181, 183),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(userId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Hiển thị widget loading khi dữ liệu đang được tải
          }
          if (snapshot.hasError) {
            return Text(
                'Something went wrong'); // Hiển thị thông báo lỗi nếu có lỗi xảy ra
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot<Object?> docSnapshot =
                    snapshot.data!.docs[index];
                Map<String, dynamic> task =
                    docSnapshot.data() as Map<String, dynamic>;
                Timestamp? datetime = task['date'];
                DateTime? date = datetime?.toDate();
                if ('$date' == '$selectedDate') {
                  String title = task['title'] ??
                      ''; // Lấy tiêu đề, sử dụng ?? để xử lý trường hợp giá trị null
                  String note = task['note'] ?? ''; // Lấy ghi chú
                  Timestamp? startTimeTimestamp = task['startTime'];
                  Timestamp? endTimeTimestamp = task['endTime'];
                  Color color = Color(task['color']); // Chuyển đổi số nguyên thành đối tượng màu
                  DateTime? startTime = startTimeTimestamp?.toDate();
                  DateTime? endTime = endTimeTimestamp?.toDate();

                  String id = task['userId'] ?? ''; // Lấy id

                  // Tạo Card để hiển thị dữ liệu
                  return GestureDetector(
                    onLongPress: () {
                      print(date);
                      _showBottomSheet(context, docSnapshot);
                    },
                    child: Card(
                      elevation: 1,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                note,
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
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.access_time, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'End: $endTime',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
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
              });
        },
      ),
    );
  }

  void _showBottomSheet(
      BuildContext context, DocumentSnapshot<Object?> document) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 230,
          width: 400,
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  document.reference.delete();

                  Navigator.pop(context);
                  print("Đã Xóa");

                  // Xử lý khi nhấn nút Delete
                },
                style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    backgroundColor: Colors.red),
                child: Text(
                  'Delete Task',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Xử lý khi nhấn nút Update

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateTask(
                              userId: userId,
                              title: document['title'],
                              note: document['note'],
                              date: (document['date'] as Timestamp)
                                  .toDate(), // Chuyển đổi Timestamp thành DateTime
                              startTime: (document['startTime'] as Timestamp)
                                  .toDate(), // Chuyển đổi Timestamp thành DateTime
                              endTime: (document['endTime'] as Timestamp)
                                  .toDate(), // Chuyển đổi Timestamp thành DateTime
                              color: document['color'],
                              documentId: document.id,
                            )),
                  );
                  
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 120, vertical: 15), //
                ),
                child: Text(
                  'Update',
                  style: TextStyle(color: Color.fromARGB(255, 26, 60, 129)),
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
