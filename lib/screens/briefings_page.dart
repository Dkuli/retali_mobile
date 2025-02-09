// briefings_page.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'package:retali/models/briefing.dart';
import '../widgets/briefing_preview_card.dart';
import 'briefing_detail_page.dart';

class BriefingsPage extends StatefulWidget {
  @override
  _BriefingsPageState createState() => _BriefingsPageState();
}

class _BriefingsPageState extends State<BriefingsPage> {
  List<Briefing> _briefings = [];
  int _selectedBriefingIndex = -1;

  Future<void> _loadBriefings() async {
    try {
      final jsonString = await rootBundle.rootBundle.loadString('assets/briefings.json');
      final jsonResponse = json.decode(jsonString);
      setState(() {
        _briefings = (jsonResponse['briefings'] as List)
            .map((data) => Briefing.fromJson(data))
            .toList();
      });
    } catch (e) {
      print("Error loading briefings: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadBriefings();
  }

  void _showBriefingDetail(Briefing briefing, int index) {
    setState(() {
      _selectedBriefingIndex = index;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BriefingDetailPage(briefing: briefing),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Panduan Umroh',
          style: theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        elevation: theme.appBarTheme.elevation,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: _briefings.isEmpty
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : Container(
              color: theme.scaffoldBackgroundColor,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: _briefings.length,
                itemBuilder: (context, index) {
                  final briefing = _briefings[index];
                  return BriefingPreviewCard(
                    briefing: briefing,
                    isSelected: index == _selectedBriefingIndex,
                    onTap: () => _showBriefingDetail(briefing, index),
                    theme: theme,
                  );
                },
              ),
            ),
    );
  }
}