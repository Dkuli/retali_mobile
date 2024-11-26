import 'package:flutter/material.dart';
import 'package:retali/GuideScreen/GuideCategory.dart';

class GuideDetailScreen extends StatelessWidget {
  final Guide guide;

  const GuideDetailScreen({
    Key? key, 
    required this.guide
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Enhanced App Bar
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            floating: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                guide.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image with gradient overlay
                  Image.network(
                    guide.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay for better text readability
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description section
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        guide.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Content section
                    Text(
                      'Content',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      guide.content,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.8,
                        letterSpacing: 0.3,
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}