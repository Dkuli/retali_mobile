import 'package:flutter/material.dart';
import 'package:retali/models/pilgrim.dart';
import 'package:retali/services/api_service.dart';

class PilgrimScreen extends StatefulWidget {
  const PilgrimScreen({Key? key}) : super(key: key);

  @override
  _PilgrimScreenState createState() => _PilgrimScreenState();
}

class _PilgrimScreenState extends State<PilgrimScreen> {
  late Future<List<Pilgrim>> _pilgrimsFuture;

  @override
  void initState() {
    super.initState();
    _pilgrimsFuture = _fetchPilgrims();
  }

  Future<List<Pilgrim>> _fetchPilgrims() async {
    final pilgrimsData = await ApiService.getPilgrims();
    return pilgrimsData.map<Pilgrim>((json) => Pilgrim.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilgrims'),
      ),
      body: FutureBuilder<List<Pilgrim>>(
        future: _pilgrimsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pilgrims found'));
          }

          final pilgrims = snapshot.data!;
          return ListView.builder(
            itemCount: pilgrims.length,
            itemBuilder: (context, index) {
              final pilgrim = pilgrims[index];
              return ListTile(
                leading: pilgrim.avatarUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(pilgrim.avatarUrl!),
                      )
                    : const CircleAvatar(child: Icon(Icons.person)),
                title: Text(pilgrim.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pilgrim.phone),
                    Text('Gender: ${pilgrim.gender}'),
                    Text('Health Notes: ${pilgrim.healthNotes}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
