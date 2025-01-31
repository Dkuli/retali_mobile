import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'package:retali/models/briefing.dart';
import '../widgets/briefing_preview_card.dart';
import 'briefing_detail_page.dart'; // Add this import statement
// Add this import statement

class BriefingsPage extends StatefulWidget {
  @override
  _BriefingsPageState createState() => _BriefingsPageState();
}

class _BriefingsPageState extends State<BriefingsPage> {
  List<Briefing> _briefings = [];
  int _selectedBriefingIndex = -1;

  Future<void> loadBriefings() async {
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
    loadBriefings();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Panduan Umroh'),
        centerTitle: true,
        backgroundColor: Colors.teal[800],
        elevation: 0,
      ),
      body: _briefings.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.grey[100],
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 16),
                itemCount: _briefings.length,
                itemBuilder: (context, index) {
                  final briefing = _briefings[index];
                  return BriefingPreviewCard(
                    briefing: briefing,
                    isSelected: index == _selectedBriefingIndex,
                    onTap: () => _showBriefingDetail(briefing, index),
                  );
                },
              ),
            ),
    );
  }
}
