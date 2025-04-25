import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String userCardNumber = '1234 5678 9012 3456'; // Replace with actual data source
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 100),
            const SizedBox(height: 20),
            const Text('Member Card Number', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(userCardNumber, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}