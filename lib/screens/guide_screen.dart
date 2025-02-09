// guide_screen.dart
import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/GuideCategory.dart';
import '../widgets/search_bar.dart';
import 'GuideDetailScreen.dart';


class GuideScreen extends StatefulWidget {
  const GuideScreen({Key? key}) : super(key: key);

  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  List<GuideCategory> categories = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    categories = DummyData.guideCategories;
  }

  List<GuideCategory> get filteredCategories {
    if (searchQuery.isEmpty) {
      return categories;
    }
    return categories.where((category) {
      final titleMatch = category.title.toLowerCase().contains(searchQuery.toLowerCase());
      final guidesMatch = category.guides.any((guide) =>
          guide.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          guide.description.toLowerCase().contains(searchQuery.toLowerCase()));
      return titleMatch || guidesMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
           appBar: AppBar(
        title: Text(
          'Pilgrims',
          style: theme.appBarTheme.titleTextStyle,
        ),
        elevation: theme.appBarTheme.elevation,
        backgroundColor: theme.primaryColor,
      ),
   
      body: CustomScrollView(
        slivers: [
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _Header(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = filteredCategories[index];
                  return _buildCategoryCard(category, theme);
                },
                childCount: filteredCategories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

 
  Widget _buildCategoryCard(GuideCategory category, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: theme.cardTheme.shape.runtimeType is RoundedRectangleBorder
            ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
            : BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: category.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(category.icon, color: category.color),
        ),
        title: Text(
          category.title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${category.guides.length} panduan',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        children: category.guides.map((guide) {
          return _buildGuideItem(guide, theme);
        }).toList(),
      ),
    );
  }

  Widget _buildGuideItem(Guide guide, ThemeData theme) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuideDetailScreen(guide: guide),
          ),
        );
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          guide.imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.error),
          ),
        ),
      ),
      title: Text(
        guide.title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        guide.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.textTheme.bodySmall?.color,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: theme.textTheme.bodyMedium?.color),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          CustomSearchBar(
            hintText: 'Cari lokasi...',
          ),
        ],
      ),
    );
  }
}