import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperInfoPage extends StatelessWidget {
  final List<DeveloperProfile> developers = [
    DeveloperProfile(
      name: 'Diandra Diva Arini',
      npm: '22082010052',
      githubUsername: 'diandradivaarini',
      email: '22082010052@student.upnjatim.ac.id',
      imageAsset: 'assets/diandra.jpg',
    ),
    DeveloperProfile(
      name: 'Grisska Adelia',
      npm: '22082010070',
      githubUsername: 'grisska',
      email: '22082010070@student.upnjatim.ac.id',
      imageAsset: 'assets/grisska.jpeg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Developer Info',
            style: TextStyle(color: Colors.white),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green[700], // Match ProfilePage color
      ),
      body: ListView.builder(
        itemCount: developers.length,
        itemBuilder: (context, index) {
          return _buildDeveloperCard(context, index);
        },
      ),
    );
  }

  Widget _buildDeveloperCard(BuildContext context, int index) {
    DeveloperProfile developer = developers[index];
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(developer.imageAsset),
            ),
            SizedBox(height: 20),
            Text(
              developer.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[900], // Darker shade of green
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 10),
            Text(
              'NPM: ${developer.npm}',
              style: TextStyle(
                color: Colors.green[700], // Match ProfilePage text color
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(
                  onPressed: () => _launchGitHub(developer.githubUsername),
                  label: 'GitHub',
                  color: Colors.green[600] ?? Colors.green, // Match button color
                ),
                _buildButton(
                  onPressed: () => _sendEmail(developer.email),
                  label: 'Email',
                  color: Colors.green[700] ?? Colors.green, // Match button color
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({required VoidCallback onPressed, required String label, required Color color}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  void _launchGitHub(String username) async {
    final url = 'https://github.com/$username';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _sendEmail(String email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Feedback',
    );
    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class DeveloperProfile {
  final String name;
  final String npm;
  final String githubUsername;
  final String email;
  final String imageAsset;

  DeveloperProfile({
    required this.name,
    required this.npm,
    required this.githubUsername,
    required this.email,
    required this.imageAsset,
  });
}
