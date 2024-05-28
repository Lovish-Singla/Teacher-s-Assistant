import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teachers_assistant/services/student_service.dart';

import '../models/student_model.dart';

class StudentListPage extends StatefulWidget {
  StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final StudentService _studentService = StudentService();
  late Future<List<Student>> _studentFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _studentFuture = _studentService.getStudents(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Student>>(
        future: _studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students found'));
          } else {
            final students = snapshot.data!;
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${student.name[0]}'),
                  ),
                  title: Text(student.name),
                  subtitle: Text(
                      'DOB: ${DateFormat('dd/MM/yyyy').format(student.dob.toLocal())}'),
                  trailing: CircleAvatar(
                    backgroundColor: student.gender == 'Male'
                        ? Colors.orange[200]
                        : student.gender == 'Female'
                            ? Colors.pink[200]
                            : Colors.grey[400],
                    child: Text(
                      '${student.gender}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                );
              },
            );
          }
        });
  }
}
