import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  DateTime _dateOfBirth = DateTime.now();
  String _gender = 'Male';
  final _dateFormat = DateFormat('dd/MM/yyyy');
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        setState(() {
          _userId = userId;
          _nameController.text = snapshot.get('name') ?? '';
          _emailController.text = snapshot.get('email') ?? '';
          _phoneNumberController.text = snapshot.get('phone') ?? '';
          _addressController.text = snapshot.get('address') ?? '';
          // Check if dateOfBirth and gender fields exist before assigning
          if (snapshot.get('dateOfBirth') != null) {
            _dateOfBirth = (snapshot.get('dateOfBirth') as Timestamp).toDate();
          }
          if (snapshot.get('gender') != null) {
            _gender = snapshot.get('gender');
          }
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileTextField(
                controller: _nameController,
                labelText: 'Name',
                icon: Icons.person,
              ),
              ProfileTextField(
                controller: _emailController,
                labelText: 'Email',
                icon: Icons.email,
                isReadOnly: true,
              ),
              ProfileTextField(
                controller: _phoneNumberController,
                labelText: 'Phone Number',
                icon: Icons.phone,
              ),
              ProfileTextField(
                controller: _addressController,
                labelText: 'Address',
                icon: Icons.home,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.green[700],
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Date of Birth',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 5),
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _dateFormat.format(_dateOfBirth),
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.calendar_today, color: Colors.green[700]),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.wc,
                    color: Colors.green[700],
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Gender',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 5),
              DropdownButtonFormField(
                value: _gender,
                items: ['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _gender = newValue.toString();
                  });
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _saveProfileData();
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green[700],
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth)
      setState(() {
        _dateOfBirth = picked;
      });
  }

  Future<void> _saveProfileData() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(_userId).update({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneNumberController.text,
        'address': _addressController.text,
        'dateOfBirth': _dateOfBirth,
        'gender': _gender,
      });

      Navigator.pop(context);
    } catch (e) {
      print('Error saving data: $e');
    }
  }
}

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isReadOnly;

  const ProfileTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isReadOnly = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.green[700],
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              labelText,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          readOnly: isReadOnly,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
