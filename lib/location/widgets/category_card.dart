import 'package:flutter/material.dart';
import 'package:retali/location/models/category.dart';
import 'package:retali/location/page/map_page.dart';


class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapPage(category: category),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.8),
                Colors.white.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category.icon,
                size: 32,
                color: Color.fromARGB(255, 78, 29, 87), // Update icon color
              ),
              const SizedBox(height: 12),
              Text(
                category.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 78, 29, 87), // Update text color
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 78, 29, 87).withOpacity(0.2), // Update background color
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${category.locationCount} lokasi',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 78, 29, 87), // Update text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}