import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:assignment1/models/stud_model.dart';
import 'package:assignment1/services/DatabaseHelper.dart';
import 'dart:io'; // Import the File class

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _gender;
  //  int _selectedItem = 1;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _nameController.text = DatabaseHelper.user.name;
    _genderController.text = DatabaseHelper.user.gender ?? '';
    _gender = DatabaseHelper.user.gender ?? '';
    _emailController.text = DatabaseHelper.user.email;
    _studentIdController.text = DatabaseHelper.user.studentId;
    _levelController.text = DatabaseHelper.user.level.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Profile Photo Section

              DatabaseHelper.profileImage != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(DatabaseHelper.profileImage!),
                    )
                  : CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person),
                    ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Profile Photo'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {
                        _uploadProfilePhoto(ImageSource.camera);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: () {
                        _uploadProfilePhoto(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              // Gender Field
              // TextFormField(
              //   controller: _genderController,
              //   decoration:
              //       const InputDecoration(labelText: 'Gender (Optional)'),
              // ),
              Row(
                children: [
                  const Text(
                    'Gender',
                    style: TextStyle(
                      // color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: const Text('Male'),
                      value: 'Male',
                      // activeColor: Colors.red,
                      groupValue: _genderController.text,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: const Text('Female'),
                      value: 'Female',
                      // activeColor: Colors.red,
                      groupValue: _genderController.text,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !value.contains('@stud.fci-cu.edu.eg')) {
                    return 'Please enter a valid FCI email';
                  }
                  return null;
                },
              ),
              // Student ID Field
              TextFormField(
                controller: _studentIdController,
                decoration: const InputDecoration(labelText: 'Student ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your student ID';
                  }
                  return null;
                },
              ),
              // Level Field
              TextFormField(
                controller: _levelController,
                decoration:
                    const InputDecoration(labelText: 'Level (Optional)'),
                validator: (value) {
                  if (value != '1' &&
                      value != '2' &&
                      value != '3' &&
                      value != '4') {
                    return 'Level  must be between 1 and 4 only';
                  }
                  return null;
                },
              ),
              //    Container(
              //   width: 345,
              //   height: 55,
              //   // decoration: BoxDecoration(
              //   //   border: Border.all(
              //   //       color: AppColor.secondaryColor, width: 2),
              //   //   borderRadius: BorderRadius.circular(15),
              //   // ),
              //   child: DropdownButton<int>(
              //     value: _selectedItem,
              //     onChanged: (int? newValue) {
              //       setState(() {
              //         _selectedItem = newValue!;
              //       });
              //     },
              //     items:
              //         <int>[1, 2, 3, 4].map<DropdownMenuItem<int>>((int value) {
              //       int levelText = value;
              //       return DropdownMenuItem<int>(
              //         value: value,
              //         child: Text(levelText.toString()),
              //       );
              //     }).toList(),
              //     underline: Container(),
              //   ),
              // ),
              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
                obscureText: true,
              ),
              // Confirm Password Field
              TextFormField(
                controller: _confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save the changes

                    var newUser = stud(
                        name: _nameController.text,
                        gender: _genderController.text,
                        email: _emailController.text,
                        studentId: _studentIdController.text,
                        level: _levelController.text != null
                            ? int.tryParse(_levelController.text!)
                            : null,
                        password: _passwordController.text.isEmpty
                            ? DatabaseHelper.user.password
                            : _passwordController.text);

                    DatabaseHelper.updateUser(newUser);
                    // After saving, you can navigate back to the previous screen
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadProfilePhoto(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      setState(() {
        DatabaseHelper.profileImage = File(pickedFile.path);
      });
    }
  }
}
