import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teachers_assistant/models/student_model.dart';
import 'package:teachers_assistant/services/student_service.dart';

import '../widgets/custom_textformfield.dart';

class StudentFormPage extends StatefulWidget {
  const StudentFormPage({super.key});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  String? _gender;
  StudentService _studentService = StudentService();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // const Text(
              //   "Enter a new Student:",
              //   style: TextStyle(
              //     fontSize: 30,
              //     fontWeight: FontWeight.bold,
              //   ),
              //   textAlign: TextAlign.left,
              // ),
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: _nameController,
                labelText: "Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: _dobController,
                labelText: 'Date of Birth',
                onTap: () async {
                  // Preventing the focus from the textfield so that the keyboard is not shown.
                  FocusScope.of(context).requestFocus(FocusNode());

                  // Showing the date picker.
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (date != null) {
                    _dobController.text = date.toIso8601String();
                    ;
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date of birth';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: InputDecoration(
                    labelText: "Gender",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                  // hint: Text('Gender'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _gender = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a gender';
                    }
                    return null;
                  },
                  items: <String>['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // First we will create a instance of current user, make a student object
                    // and then add the student.
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final student = Student(
                        name: _nameController.text,
                        dob: DateTime.parse(_dobController.text),
                        gender: _gender!,
                      );
                      await _studentService.addStudent(user.uid, student);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Student added successfully')),
                      );
                      _formKey.currentState!.reset();
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ));
  }
}
