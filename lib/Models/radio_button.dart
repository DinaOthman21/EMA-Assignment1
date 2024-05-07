import 'package:flutter/material.dart';
// import 'package:task_one/models/colors.dart';

class GenderSelection extends StatefulWidget {
  const GenderSelection({super.key});

  @override
  _GenderSelectionState createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  String? _selectedGender;
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: const Text('Male'),
            value: 'Male',
            activeColor: Colors.red,
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: const Text('Female'),
            value: 'Female',
            activeColor: Colors.red,
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
}
