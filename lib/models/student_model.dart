import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  String name;
  DateTime dob;
  String gender;

  Student({
    required this.name,
    required this.dob,
    required this.gender,
  });

  factory Student.fromMap(Map<String, dynamic> data) {
    return Student(
      name: data['name'],
      dob: (data['dob'] as Timestamp).toDate(),
      gender: data['gender'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dob': dob,
      'gender': gender,
    };
  }
}
