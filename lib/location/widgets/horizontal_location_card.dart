import 'package:flutter/material.dart';
import '../models/location.dart';

class HorizontalLocationCard extends StatelessWidget {
  final Location location;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onNavigate;

  const HorizontalLocationCard({
    super.key,
    required this.location,
    required this.isSelected,
    required this.onTap,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        color: isSelected 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1) 
            : Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _LocationImage(location: location),
        const SizedBox(width: 12),
        _LocationInfo(location: location),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _CoordinatesDisplay(location: location),
        _NavigationButton(onNavigate: onNavigate),
      ],
    );
  }
}

class _LocationImage extends StatelessWidget {
  final Location location;

  const _LocationImage({required this.location});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: location.id,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            location.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _LocationInfo extends StatelessWidget {
  final Location location;

  const _LocationInfo({required this.location});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            location.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            location.address,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _CoordinatesDisplay extends StatelessWidget {
  final Location location;

  const _CoordinatesDisplay({required this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          '${location.lat.toStringAsFixed(4)}, ${location.lng.toStringAsFixed(4)}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final VoidCallback onNavigate;

  const _NavigationButton({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onNavigate,
      icon: const Icon(Icons.directions, size: 16),
      label: const Text('Rute'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 78, 29, 87),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}