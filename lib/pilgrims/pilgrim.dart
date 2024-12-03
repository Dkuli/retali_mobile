import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PilgrimList(),
    );
  }
}

class Pilgrim {
  final String photoUrl;
  final String name;
  final String phoneNumber;
  final String healthNotes;
  final String gender;

  Pilgrim({
    required this.photoUrl,
    required this.name,
    required this.phoneNumber,
    required this.healthNotes,
    required this.gender,
  });
}

class PilgrimList extends StatelessWidget {
  final List<Pilgrim> pilgrims = [
    Pilgrim(
      photoUrl: 'https://example.com/photo1.jpg',
      name: 'John Doe',
      phoneNumber: '123-456-7890',
      healthNotes: 'Diabetic',
      gender: 'Male',
    ),
    Pilgrim(
      photoUrl: 'https://example.com/photo2.jpg',
      name: 'Jane Smith',
      phoneNumber: '098-765-4321',
      healthNotes: 'None',
      gender: 'Female',
    ),
    // Add more pilgrims here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilgrim List'),
      ),
      body: ListView.builder(
        itemCount: pilgrims.length,
        itemBuilder: (context, index) {
          final pilgrim = pilgrims[index];
          return ListTile(
            leading: Image.network(pilgrim.photoUrl),
            title: Text(pilgrim.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Phone: ${pilgrim.phoneNumber}'),
                Text('Health Notes: ${pilgrim.healthNotes}'),
                Text('Gender: ${pilgrim.gender}'),
              ],
            ),
          );
        },
      ),
    );
  }
}