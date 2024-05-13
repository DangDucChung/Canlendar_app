import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateTask extends StatefulWidget {
  final String userId;
  final String title;
  final String note;
  final DateTime startTime;
  final DateTime endTime;
  final int color;
  final DateTime date;
  final String documentId;
  UpdateTask({
    required this.userId,
    required this.title,
    required this.note,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.date,
    required this.documentId,
  });

  @override
  _UpdateTaskState createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedStartTime;
  late TimeOfDay _selectedEndTime;
  late Color _selectedColor;

  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    _titleController = TextEditingController(text: widget.title);
    _noteController = TextEditingController(text: widget.note);
    _selectedDate = widget.date;
    _selectedStartTime = TimeOfDay.fromDateTime(widget.startTime);
    _selectedEndTime = TimeOfDay.fromDateTime(widget.endTime);
    _selectedColor = Color(widget.color);
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
        title: Text('Update Task'),
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
                readOnly: true,
                controller: TextEditingController(
                  text: DateFormat('yyyy-MM-dd').format(_selectedDate),
                ),
                onTap: () {
                  _selectDate(context);
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),
                  hintText: 'Select date',
                ),
              ),
              Text(
                'Start Time:',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: _selectedStartTime.format(context),
                ),
                onTap: () {
                  _selectStartTime(context);
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.access_time),
                  hintText: 'Select time',
                ),
              ),
              Text(
                'End Time:',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: _selectedEndTime.format(context),
                ),
                onTap: () {
                  _selectEndTime(context);
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.access_time),
                  hintText: 'Select time',
                ),
              ),
              Text(
                'Color:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
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
       firstDate: DateTime(1900), // Bất kỳ ngày trong quá khứ nào
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
    final id = DateTime.now().microsecond.toString();
    String title = _titleController.text;
    String note = _noteController.text;
    String document = widget.documentId;
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
        'title: $title, note: $note, Date: $Date, startTime: $startTime, endTime: $endTime, color: $color,');
    print(document);
    try {
      await _firestore.collection(widget.userId).doc(widget.documentId).update({
        'title': title,
        'date': Date,
        'note': note,
        'startTime': startTime,
        'endTime': endTime,
        'color': color.value,
      });
    } catch (error) {
      print('Error: $error');
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
