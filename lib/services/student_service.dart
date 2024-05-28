import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teachers_assistant/models/student_model.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addStudent(String teacherId, Student student) async {
    await _firestore
        .collection('teachers')
        .doc(teacherId)
        .collection('students')
        .add(student.toMap());
  }

  Future<List<Student>> getStudents(String teacherId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('teachers')
        .doc(teacherId)
        .collection('students')
        .get();
    return querySnapshot.docs
        .map((doc) => Student.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
