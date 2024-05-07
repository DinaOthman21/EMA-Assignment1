import 'package:flutter/material.dart';
import 'package:assignment1/models/stud_model.dart';
import 'package:assignment1/services/DatabaseHelper.dart';
import 'package:assignment1/models/radio_button.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: const SignupForm(),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  // int _selectedItem = 1;
  //  String? _selectedGender;
  String? _name;
  String? _gender;
  String? _email;
  String? _studentId;
  String? _level;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name *'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value;
              },
            ),
            // TextFormField(
            //   decoration: const InputDecoration(labelText: 'Gender (Optional)'),
            //   onSaved: (value) {
            //     _gender = value;
            //   },
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
                    groupValue: _gender,
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
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            TextFormField(
              decoration: const InputDecoration(labelText: 'Email *'),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !value.contains('@stud.fci-cu.edu.eg')) {
                  return 'Please enter a valid FCI email';
                }
                return null;
              },
              onSaved: (value) {
                _email = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Student ID *'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your student ID';
                }
                return null;
              },
              onSaved: (value) {
                _studentId = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Level (Optional)'),
              onSaved: (value) {
                _level = value;
              },
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
            // Container(
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
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password *'),
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
              obscureText: true,
            ),
            TextFormField(
              controller: _confirmPasswordController,
              decoration:
                  const InputDecoration(labelText: 'Confirm Password *'),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  // Create a stud object with the entered data
                  stud newUser = stud(
                    name: _name!,
                    gender: _gender,
                    email: _email!,
                    studentId: _studentId!,
                    level: _level != null ? int.tryParse(_level!) : null,
                    password: _passwordController.text,
                  );

                  try {
                    // Insert the user into the database
                    int userId = await DatabaseHelper.insertUser(newUser);
                    // print("- - ------------------------------------------ ");
                    // print(userId);
                    // print(
                    //     "___________________------------------------------------________");

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(userId.toString()),
                      ),
                    );
                    Navigator.pushNamed(context, '/home');

                    // if (userId >= 0) {
                    //   // Print signup success
                    //   print('Signup success');

                    //   // // Navigate to the home screen
                    //   //  Navigator.pushReplacementNamed(context, '/home');

                    // } else {
                    //   // Handle insertion failure
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: Text('Failed to save user data.'),
                    //     ),
                    //   );
                    // }
                  } catch (e) {
                    // Handle insertion error
                    print('Error inserting user: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('An error occurred while saving user data.'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
