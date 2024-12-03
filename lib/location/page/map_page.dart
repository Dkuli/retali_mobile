import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/category.dart';
import '../models/location.dart';
import '../widgets/horizontal_location_card.dart';
import '../widgets/search_bar.dart';

class MapPage extends StatefulWidget {
  final Category category;

  const MapPage({
    super.key,
    required this.category,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location? _selectedLocation;
  GoogleMapController? _mapController;
  static const CameraPosition _jakartaCenter = CameraPosition(
    target: LatLng(-6.200000, 106.816666),
    zoom: 13,
  );
  Set<Marker> _markers = {};

  Future<void> _openGoogleMaps(Location location) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${location.lat},${location.lng}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _selectLocation(Location location) {
    setState(() {
      _selectedLocation = location;
    });
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(location.lat, location.lng),
        15,
      ),
    );
  }

  void _updateMarkers() {
    setState(() {
      _markers = widget.category.locations.map((location) {
        return Marker(
          markerId: MarkerId(location.id),
          position: LatLng(location.lat, location.lng),
          icon: _selectedLocation == location 
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () => _selectLocation(location),
        );
      }).toSet();
    });
  }

  @override
  void initState() {
    super.initState();
    _updateMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _MapView(
            category: widget.category,
            markers: _markers,
            onMapCreated: (controller) => _mapController = controller,
          ),
          _TopSearchBar(category: widget.category),
          _LocationsList(
            category: widget.category,
            selectedLocation: _selectedLocation,
            onLocationSelect: _selectLocation,
            onNavigate: _openGoogleMaps,
          ),
        ],
      ),
    );
  }
}

class _MapView extends StatelessWidget {
  final Category category;
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;

  const _MapView({
    required this.category,
    required this.markers,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: category.locations.isNotEmpty
          ? CameraPosition(
              target: LatLng(
                category.locations[0].lat,
                category.locations[0].lng,
              ),
              zoom: 13,
            )
          : const CameraPosition(
              target: LatLng(-6.200000, 106.816666),
              zoom: 13,
            ),
      markers: markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      mapType: MapType.normal,
    );
  }
}

class _TopSearchBar extends StatelessWidget {
  final Category category;

  const _TopSearchBar({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        8,
        MediaQuery.of(context).padding.top + 8,
        8,
        8,
      ),
      color: Colors.transparent,
      child: Card(
        margin: EdgeInsets.zero,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
              style: IconButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            Expanded(
              child: CustomSearchBar(
                hintText: 'Cari ${category.name}...',
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationsList extends StatelessWidget {
  final Category category;
  final Location? selectedLocation;
  final Function(Location) onLocationSelect;
  final Function(Location) onNavigate;

  const _LocationsList({
    required this.category,
    required this.selectedLocation,
    required this.onLocationSelect,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 16,
      child: SizedBox(
        height: 160,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: category.locations.length,
          itemBuilder: (context, index) {
            final location = category.locations[index];
            return HorizontalLocationCard(
              location: location,
              isSelected: selectedLocation == location,
              onTap: () => onLocationSelect(location),
              onNavigate: () => onNavigate(location),
            );
          },
        ),
      ),
    );
  }
}