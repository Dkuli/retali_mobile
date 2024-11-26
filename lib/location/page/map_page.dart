
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
  final MapController _mapController = MapController();
  static const LatLng _jakartaCenter = LatLng(-6.200000, 106.816666);

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
    _mapController.move(
      LatLng(location.lat, location.lng),
      15,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _MapView(
            category: widget.category,
            selectedLocation: _selectedLocation,
            mapController: _mapController,
            onLocationSelect: _selectLocation,
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
  final Location? selectedLocation;
  final MapController mapController;
  final Function(Location) onLocationSelect;

  const _MapView({
    required this.category,
    required this.selectedLocation,
    required this.mapController,
    required this.onLocationSelect,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: category.locations.isNotEmpty
            ? LatLng(
                category.locations[0].lat,
                category.locations[0].lng,
              )
            : const LatLng(-6.200000, 106.816666),
        initialZoom: 13,
        onTap: (_, __) => onLocationSelect(selectedLocation!),
      ),
      children: [
        _MapTileLayer(),
        _LocationMarkers(
          category: category,
          selectedLocation: selectedLocation,
          onLocationSelect: onLocationSelect,
        ),
      ],
    );
  }
}

class _MapTileLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.app',
    );
  }
}

class _LocationMarkers extends StatelessWidget {
  final Category category;
  final Location? selectedLocation;
  final Function(Location) onLocationSelect;

  const _LocationMarkers({
    required this.category,
    required this.selectedLocation,
    required this.onLocationSelect,
  });

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: category.locations.map((location) {
        return Marker(
          width: 50,
          height: 50,
          point: LatLng(location.lat, location.lng),
          child: _LocationMarker(
            location: location,
            isSelected: selectedLocation == location,
            onTap: () => onLocationSelect(location),
            categoryIcon: category.icon,
          ),
        );
      }).toList(),
    );
  }
}

class _LocationMarker extends StatelessWidget {
  final Location location;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData categoryIcon;

  const _LocationMarker({
    required this.location,
    required this.isSelected,
    required this.onTap,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(
            categoryIcon,
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
      ),
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