
import 'package:flutter/material.dart';
import 'package:retali/location/widgets/category_card.dart';
import '../data/dummy_data.dart';


class LocationsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari lokasi...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),

            // Categories Grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: DummyData.categories.length,
                itemBuilder: (context, index) {
                  return CategoryCard(
                    category: DummyData.categories[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}