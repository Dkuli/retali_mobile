// briefing_detail_page.dart
import 'package:flutter/material.dart';
import '../models/briefing.dart';

class BriefingDetailPage extends StatelessWidget {
  final Briefing briefing;

  const BriefingDetailPage({Key? key, required this.briefing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          briefing.type,
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              briefing.opening,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            if (briefing.introduction != null)
              _buildSection('Pendahuluan', briefing.introduction!, theme),
            if (briefing.description != null)
              _buildSection('Deskripsi', briefing.description!, theme),
            if (briefing.closing.isNotEmpty)
              _buildSection('Penutup', briefing.closing, theme),
          ],
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }

  Widget _buildSection(String title, String content, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 16,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}