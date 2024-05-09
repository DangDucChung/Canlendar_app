import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTask createState() => _AddTask();
  final String userId;

  AddTask({required this.userId});
}

class _AddTask extends State<AddTask> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedStartTime;
  late TimeOfDay _selectedEndTime;
  late Color _selectedColor;

  final _formKey = GlobalKey<FormState>();
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _noteController = TextEditingController();
    _selectedDate = DateTime.now();
    _selectedStartTime = TimeOfDay.now();
    _selectedEndTime = TimeOfDay.now();
    _selectedColor = _colors[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveReminder(context);
                }
              },
              child: Text('Save'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title:',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Note:',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                controller: _noteController,
              ),
              SizedBox(height: 20),
              Text(
                'Date:',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                readOnly:
                    true, // Đặt thuộc tính readOnly để ngăn người dùng chỉnh sửa trực tiếp
                controller: TextEditingController(
                  text: DateFormat('yyyy-MM-dd')
                      .format(_selectedDate), // Định dạng ngày tháng năm
                ),
                onTap: () {
                  _selectDate(
                      context); // Gọi hàm _selectEndTime khi người dùng chạm vào TextField
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons
                      .calendar_today), // Sử dụng prefixIcon để thêm biểu tượng
                  hintText: 'Select date', // Thêm gợi ý khi không có giá trị
                ),
              ),
              Text(
                'Start Time:',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                readOnly:
                    true, // Đặt thuộc tính readOnly để ngăn người dùng chỉnh sửa trực tiếp
                controller: TextEditingController(
                  text: _selectedStartTime.format(
                      context), // Sử dụng phương thức format để chuyển đổi TimeOfDay thành chuỗi
                ),
                onTap: () {
                  _selectStartTime(
                      context); // Gọi hàm _selectEndTime khi người dùng chạm vào TextField
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons
                      .access_time), // Sử dụng prefixIcon để thêm biểu tượng
                  hintText: 'Select time', // Thêm gợi ý khi không có giá trị
                ),
              ),
              Text(
                'End Time:',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                readOnly:
                    true, // Đặt thuộc tính readOnly để ngăn người dùng chỉnh sửa trực tiếp
                controller: TextEditingController(
                  text: _selectedEndTime.format(
                      context), // Sử dụng phương thức format để chuyển đổi TimeOfDay thành chuỗi
                ),
                onTap: () {
                  _selectEndTime(
                      context); // Gọi hàm _selectEndTime khi người dùng chạm vào TextField
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons
                      .access_time), // Sử dụng prefixIcon để thêm biểu tượng
                  hintText: 'Select time', // Thêm gợi ý khi không có giá trị
                ),
              ),
              Text(
                'Color:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              DropdownButton<Color>(
                value: _selectedColor,
                onChanged: (Color? newValue) {
                  setState(() {
                    _selectedColor = newValue!;
                  });
                },
                items: _colors.map<DropdownMenuItem<Color>>((Color color) {
                  return DropdownMenuItem<Color>(
                    value: color,
                    child: Container(
                      width: 20,
                      height: 20,
                      color: color,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedStartTime = pickedTime;
      });
    }
  }

  void _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedEndTime = pickedTime;
      });
    }
  }

  void _saveReminder(BuildContext context) async {
    // Lưu thông tin nhắc nhở ở đây
    final id = DateTime.now().microsecond.toString();
    String title = _titleController.text;
    String note = _noteController.text;

    // Lấy ngày từ _selectedDate
    DateTime Date = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    DateTime startTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedStartTime.hour,
      _selectedStartTime.minute,
    );
    DateTime endTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedEndTime.hour,
      _selectedEndTime.minute,
    );
    Color color = _selectedColor;
    print(
        'title: $title, note: $note,Date: $Date, startTime:$startTime,endTime:$endTime, color: $color');
    // Sau khi lưu xong, quay trở lại màn hình trước đó
    // Lưu dữ liệu vào Firebase Database
    try {
      // Sử dụng phương thức push() để tạo một nút mới với một ID tự động
      await _database.child(widget.userId).push().set({
        'userId': id, // Lấy userId từ widget
        'title': title,
        'date':
            Date.toString(), // Chuyển DateTime thành String để lưu vào database
        'note': note,
        'startTime': startTime
            .toString(), // Chuyển DateTime thành String để lưu vào database
        'endTime': endTime
            .toString(), // Chuyển DateTime thành String để lưu vào database
        'color': color.value, // Lưu giá trị hex của màu vào database
      });
    } catch (error) {
      print('lỗi: $error');
    }
    Navigator.pop(context);
  }
}
