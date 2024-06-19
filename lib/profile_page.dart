import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'edit_profile.dart';
import 'developer_info.dart'; // Import file developer_info.dart
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _name;
  late String _email;
  late String _phoneNumber;
  late String _address;
  late Timestamp? _dateOfBirth;
  late String _gender;

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _name = '';
    _email = '';
    _phoneNumber = '';
    _address = '';
    _dateOfBirth = null;
    _gender = '';
  }

  Future<void> _getProfileData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        setState(() {
          _name = snapshot.get('name') ?? '';
          _email = snapshot.get('email') ?? '';
          _phoneNumber = snapshot.get('phone') ?? '';
          _address = snapshot.get('address') ?? '';
          _dateOfBirth = (snapshot.data() as Map<String, dynamic>)
                  .containsKey('dateOfBirth')
              ? snapshot.get('dateOfBirth')
              : null;
          _gender =
              (snapshot.data() as Map<String, dynamic>).containsKey('gender')
                  ? snapshot.get('gender')
                  : '-';
          _isLoading = false;
        });
      } else {
        setState(() {
          _name = '';
          _email = '';
          _phoneNumber = '';
          _address = '';
          _dateOfBirth = null;
          _gender = '';
          _isLoading = false;
          _errorMessage = 'Document does not exist';
        });
        print('Document does not exist');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching data: $e';
      });
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Title text center alignment
        backgroundColor: Colors.green[700],
        iconTheme:
            IconThemeData(color: Colors.white), // Set icon color to white
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeveloperInfoPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: _getProfileData(),
          builder: (context, snapshot) {
            if (_isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (_errorMessage.isNotEmpty) {
              return Center(child: Text(_errorMessage));
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 67, 70, 67),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.account_circle,
                            color: Colors.green[700], size: 30),
                        SizedBox(width: 10),
                        Text(
                          'Personal Information',
                          style: GoogleFonts.bellefair(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ProfileDetail(label: 'Name', value: _name),
                  ProfileDetail(label: 'Email', value: _email),
                  ProfileDetail(label: 'Phone Number', value: _phoneNumber),
                  ProfileDetail(label: 'Address', value: _address),
                  ProfileDetail(
                      label: 'Date of Birth',
                      value: _dateOfBirth != null
                          ? DateFormat('dd MMMM yyyy')
                              .format(_dateOfBirth!.toDate())
                          : '-'),
                  ProfileDetail(label: 'Gender', value: _gender),
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage()),
                        ).then((_) {
                          _getProfileData();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green[700],
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 30.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            }
          },
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green[700],
              ),
              child: Center(
                child: Text(
                  'Developer Info',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('About Us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeveloperInfoPage()),
                );
              },
            ),
            // Add more menu options if needed
          ],
        ),
      ),
    );
  }
}

class ProfileDetail extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDetail({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Center the details
      children: [
        Text(
          label,
          style: GoogleFonts.bellefair(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: GoogleFonts.bellefair(
            fontSize: 20,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 20),
        Divider(color: Colors.grey),
      ],
    );
  }
}
