import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/luggage_scan.dart';
import '../services/api_service.dart';

class LuggageScanHistoryScreen extends StatefulWidget {
  const LuggageScanHistoryScreen({Key? key}) : super(key: key);

  @override
  State<LuggageScanHistoryScreen> createState() => _LuggageScanHistoryScreenState();
}

class _LuggageScanHistoryScreenState extends State<LuggageScanHistoryScreen> {
  late Future<List<LuggageScan>> _scansFuture;
  late Future<Map<String, dynamic>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    _scansFuture = ApiService.getMyLuggageScans();
    _statsFuture = ApiService.getMyLuggageStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _refreshData();
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _refreshData();
          });
        },
        child: Column(
          children: [
            // Stats Card
            FutureBuilder<Map<String, dynamic>>(
              future: _statsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final stats = snapshot.data!;
                  return Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            'Total Scans',
                            stats['total_scans'].toString(),
                          ),
                          _buildStatItem(
                            'Today',
                            stats['today_scans'].toString(),
                          ),
                          _buildStatItem(
                            'Unique Luggage',
                            stats['unique_luggage'].toString(),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox(height: 100);
              },
            ),

            // Scan List
            Expanded(
              child: FutureBuilder<List<LuggageScan>>(
                future: _scansFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  final scans = snapshot.data!;
                  
                  if (scans.isEmpty) {
                    return const Center(
                      child: Text('No scan history found'),
                    );
                  }

                  return ListView.builder(
                    itemCount: scans.length,
                    itemBuilder: (context, index) {
                      final scan = scans[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(
                            scan.luggage.pilgrimName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Luggage: ${scan.luggage.number}'),
                              Text('Group: ${scan.luggage.group}'),
                              Text('Scanned: ${scan.scannedAtHuman}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.map),
                            onPressed: () {
                              _showLocationDialog(context, scan);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _showLocationDialog(BuildContext context, LuggageScan scan) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(scan.latitude, scan.longitude),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(scan.id.toString()),
                      position: LatLng(scan.latitude, scan.longitude),
                    ),
                  },
                ),
              ),
              TextButton(
                child: const Text('Close'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}