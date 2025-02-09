// briefings_page.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'package:retali/models/briefing.dart';
import '../widgets/briefing_preview_card.dart';


class BriefingsPage extends StatefulWidget {
  @override
  _BriefingsPageState createState() => _BriefingsPageState();
}

class _BriefingsPageState extends State<BriefingsPage> {
  List<Briefing> _briefings = [];
  Map<String, List<Briefing>> _categorizedBriefings = {};
  int _selectedBriefingIndex = -1;

  Future<void> _loadBriefings() async {
    try {
      final jsonString = await rootBundle.rootBundle.loadString('assets/briefings.json');
      final jsonResponse = json.decode(jsonString);
      final List<Briefing> loadedBriefings = (jsonResponse['briefings'] as List)
          .map((data) => Briefing.fromJson(data))
          .toList();

      // Categorize briefings by type
      final Map<String, List<Briefing>> categorized = {};
      for (var briefing in loadedBriefings) {
        if (!categorized.containsKey(briefing.type)) {
          categorized[briefing.type] = [];
        }
        categorized[briefing.type]!.add(briefing);
      }

      setState(() {
        _briefings = loadedBriefings;
        _categorizedBriefings = categorized;
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
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      briefing.type,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (briefing.opening.isNotEmpty) ...[
                            Text(
                              briefing.opening,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (briefing.introduction?.isNotEmpty ?? false) ...[
                            Text(
                              briefing.introduction!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (briefing.description?.isNotEmpty ?? false) ...[
                            Text(
                              briefing.description!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (briefing.closing.isNotEmpty) ...[
                            Text(
                              briefing.closing,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                                height: 1.6,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection(String title, Map<String, String> content, ThemeData theme) {
    // Only show sections that have content
    if (content.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...content.entries.where((entry) => entry.value.isNotEmpty).map((entry) => Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.value,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Panduan Umroh',
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: _briefings.isEmpty
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : Container(
              color: Colors.white,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _categorizedBriefings.length,
                itemBuilder: (context, index) {
                  final type = _categorizedBriefings.keys.elementAt(index);
                  final briefingsInCategory = _categorizedBriefings[type]!;
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ExpansionTile(
                      maintainState: true,
                      shape: const Border(),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.menu_book,
                          color: theme.primaryColor,
                        ),
                      ),
                      title: Text(
                        type,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: briefingsInCategory.map((briefing) {
                        final briefingIndex = _briefings.indexOf(briefing);
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                          ),
                          child: ListTile(
                            onTap: () => _showBriefingDetail(briefing, briefingIndex),
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: theme.primaryColor.withOpacity(0.1),
                              child: Text(
                                '${briefingIndex + 1}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              briefing.opening,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: theme.primaryColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
    );
  }
}