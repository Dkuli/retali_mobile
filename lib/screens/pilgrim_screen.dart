import 'package:flutter/material.dart';
import 'package:retali/services/api_service.dart';

import '../models/pilgrim.dart';


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
        title: const Text(
          'Pilgrims',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        elevation: 2,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder<List<Pilgrim>>(
        future: _pilgrimsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No pilgrims found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final pilgrims = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: pilgrims.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final pilgrim = pilgrims[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: pilgrim.avatarUrl != null
                              ? Image.network(
                                  pilgrim.avatarUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.person),
                                )
                              : const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pilgrim.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  pilgrim.phone,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Gender: ${pilgrim.gender}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            if (pilgrim.healthNotes.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.health_and_safety, size: 16),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Health: ${pilgrim.healthNotes}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}