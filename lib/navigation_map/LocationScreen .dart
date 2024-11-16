import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentPosition;
  final List<Marker> _markers = [];
  
  // Koordinat Makkah sebagai default center
  final LatLng meccaLocation = LatLng(21.422510, 39.826168);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _addDefaultMarkers();
  }

  void _addDefaultMarkers() {
    // Marker untuk Masjidil Haram
    _markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(21.422510, 39.826168),
        child: _buildMarkerWidget(
          "Masjidil Haram",
          Icons.mosque,
          Colors.green,
        ),
      ),
    );

    // Marker untuk Masjid Nabawi
    _markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(24.468611, 39.611389),
        child: _buildMarkerWidget(
          "Masjid Nabawi",
          Icons.mosque,
          Colors.green,
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: _currentPosition!,
            child: _buildMarkerWidget(
              "Lokasi Anda",
              Icons.location_on,
              Colors.blue,
            ),
          ),
        );
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Widget _buildMarkerWidget(String title, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  void _openGoogleMaps(LatLng destination) async {
    if (_currentPosition == null) return;
    
    final url = 'https://www.google.com/maps/dir/?api=1&origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${destination.latitude},${destination.longitude}&travelmode=driving';
    
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka Google Maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Lokasi'),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: const Color.fromARGB(255, 78, 29, 87),
      actions: [
        IconButton(
        icon: const Icon(Icons.my_location, color: Colors.white),
        onPressed: () {
          if (_currentPosition != null) {
          _mapController.move(_currentPosition!, 15);
          }
        },
        ),
      ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: meccaLocation,
              initialZoom: 15,
              maxZoom: 18,
              minZoom: 3,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(markers: _markers),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Lokasi Penting',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildLocationButton(
                      'Masjidil Haram',
                      Icons.mosque,
                      () => _openGoogleMaps(meccaLocation),
                    ),
                    const Divider(),
                    _buildLocationButton(
                      'Masjid Nabawi',
                      Icons.mosque,
                      () => _openGoogleMaps(LatLng(24.468611, 39.611389)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationButton(String title, IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: const Color.fromARGB(255, 78, 29, 87)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Icon(Icons.directions, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}