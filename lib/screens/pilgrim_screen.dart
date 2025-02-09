// pilgrim_screen.dart
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
    return pilgrimsData.map((json) => Pilgrim.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pilgrims',
          style: theme.appBarTheme.titleTextStyle,
        ),
        elevation: theme.appBarTheme.elevation,
        backgroundColor: theme.primaryColor,
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
                elevation: theme.cardTheme.elevation,
                shape: theme.cardTheme.shape,
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
                            color: theme.primaryColor,
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
                              style: theme.textTheme.headlineLarge?.copyWith(
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
                                  style: theme.textTheme.bodyMedium,
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
                                  style: theme.textTheme.bodyMedium,
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
                                      style: theme.textTheme.bodyMedium,
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