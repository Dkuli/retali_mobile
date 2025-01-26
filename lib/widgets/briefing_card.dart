import 'package:flutter/material.dart';
import 'package:retali/models/briefing.dart';


class BriefingCard extends StatefulWidget {
  final Briefing briefing;

  const BriefingCard({Key? key, required this.briefing}) : super(key: key);

  @override
  State<BriefingCard> createState() => _BriefingCardState();
}

class _BriefingCardState extends State<BriefingCard> {
  List<bool> _expandedSections = List.generate(10, (_) => false);
  
  Widget _buildHeaderTile() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        '${widget.briefing.type} ${widget.briefing.location != null ? 'di ${widget.briefing.location!}' : ''}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal[700],
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          widget.briefing.opening,
          style: TextStyle(fontSize: 14),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildMapContent(Map<String, String>? data) {
    if (data == null || data.isEmpty) return SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((entry) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.teal[700],
              ),
            ),
            SizedBox(height: 4),
            Text(
              entry.value,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      )).toList(),
    );
  }

  List<ExpansionPanel> _buildExpansionPanels() {
    List<ExpansionPanelContent> sections = [];

    // Add introduction if exists
    if (widget.briefing.introduction != null) {
      sections.add(ExpansionPanelContent(
        'Pendahuluan',
        widget.briefing.introduction!,
        isText: true
      ));
    }

    // Add description if exists
    if (widget.briefing.description != null) {
      sections.add(ExpansionPanelContent(
        'Deskripsi',
        widget.briefing.description!,
        isText: true
      ));
    }

    // Add other sections if they exist
    if (widget.briefing.jamaahPreparedness?.isNotEmpty ?? false) {
      sections.add(ExpansionPanelContent(
        'Persiapan Jamaah',
        widget.briefing.jamaahPreparedness!
      ));
    }

    if (widget.briefing.administrationCheck?.isNotEmpty ?? false) {
      sections.add(ExpansionPanelContent(
        'Pengecekan Administrasi',
        widget.briefing.administrationCheck!
      ));
    }

    if (widget.briefing.coordination?.isNotEmpty ?? false) {
      sections.add(ExpansionPanelContent(
        'Koordinasi',
        widget.briefing.coordination!
      ));
    }

    if (widget.briefing.importantInformation?.isNotEmpty ?? false) {
      sections.add(ExpansionPanelContent(
        'Informasi Penting',
        widget.briefing.importantInformation!
      ));
    }

    return List.generate(sections.length, (index) {
      final section = sections[index];
      return ExpansionPanel(
        headerBuilder: (context, isExpanded) => ListTile(
          title: Text(
            section.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: section.isText
              ? Text(section.content as String)
              : _buildMapContent(section.content as Map<String, String>),
        ),
        isExpanded: _expandedSections[index],
        canTapOnHeader: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildHeaderTile(),
          ExpansionPanelList(
            elevation: 0,
            expandedHeaderPadding: EdgeInsets.zero,
            expansionCallback: (index, isExpanded) {
              setState(() {
                _expandedSections[index] = !isExpanded;
              });
            },
            children: _buildExpansionPanels(),
          ),
          if (widget.briefing.closing.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.briefing.closing,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ExpansionPanelContent {
  final String title;
  final dynamic content;
  final bool isText;

  ExpansionPanelContent(this.title, this.content, {this.isText = false});
}