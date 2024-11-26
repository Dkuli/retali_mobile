
import 'package:flutter/material.dart';
import 'location.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final List<Location> locations;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.locations,
  });

  int get locationCount => locations.length;
}