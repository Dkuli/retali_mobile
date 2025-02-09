// briefing_card.dart
import 'package:flutter/material.dart';
import '../models/briefing.dart';

class BriefingCard extends StatefulWidget {
  final Briefing briefing;
  const BriefingCard({super.key, required this.briefing}); // Convert 'key' to super parameter

  @override
  BriefingCardState createState() => BriefingCardState(); // Make the private type public
}

class BriefingCardState extends State<BriefingCard> {
  List<bool> isExpanded = [false, false, false, false, false, false]; // Use a list to track expansion state

  Widget _buildHeaderTile(ThemeData theme) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        '${widget.briefing.type} ${widget.briefing.location != null ? 'di ${widget.briefing.location!}' : ''}',
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.primaryColor,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          widget.briefing.opening,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildMapContent(Map<String, String> data, ThemeData theme) {
    if (data.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.value,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          )).toList(),
    );
  }

  List<ExpansionPanel> _buildExpansionPanels(ThemeData theme) {
    final List<ExpansionPanel> panels = [];
    // Add introduction if exists
    if (widget.briefing.introduction != null) {
      panels.add(
        ExpansionPanel(
          headerBuilder: (context, isExpanded) => ListTile(
            title: Text(
              'Pendahuluan',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              widget.briefing.introduction!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ),
          isExpanded: this.isExpanded[0], // Use list to track expansion state
          canTapOnHeader: true,
        ),
      );
    }
    // Add description if exists
    if (widget.briefing.description != null) {
      panels.add(
        ExpansionPanel(
          headerBuilder: (context, isExpanded) => ListTile(
            title: Text(
              'Deskripsi',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              widget.briefing.description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ),
          isExpanded: this.isExpanded[1], // Use list to track expansion state
          canTapOnHeader: true,
        ),
      );
    }
    // Add other sections if they exist
    if (widget.briefing.jamaahPreparedness?.isNotEmpty ?? false) {
      panels.add(
        ExpansionPanel(
          headerBuilder: (context, isExpanded) => ListTile(
            title: Text(
              'Persiapan Jamaah',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildMapContent(widget.briefing.jamaahPreparedness!, theme),
          ),
          isExpanded: this.isExpanded[2], // Use list to track expansion state
          canTapOnHeader: true,
        ),
      );
    }
    if (widget.briefing.administrationCheck?.isNotEmpty ?? false) {
      panels.add(
        ExpansionPanel(
          headerBuilder: (context, isExpanded) => ListTile(
            title: Text(
              'Pengecekan Administrasi',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildMapContent(widget.briefing.administrationCheck!, theme),
          ),
          isExpanded: this.isExpanded[3], // Use list to track expansion state
          canTapOnHeader: true,
        ),
      );
    }
    if (widget.briefing.coordination?.isNotEmpty ?? false) {
      panels.add(
        ExpansionPanel(
          headerBuilder: (context, isExpanded) => ListTile(
            title: Text(
              'Koordinasi',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildMapContent(widget.briefing.coordination!, theme),
          ),
          isExpanded: this.isExpanded[4], // Use list to track expansion state
          canTapOnHeader: true,
        ),
      );
    }
    if (widget.briefing.importantInformation?.isNotEmpty ?? false) {
      panels.add(
        ExpansionPanel(
          headerBuilder: (context, isExpanded) => ListTile(
            title: Text(
              'Informasi Penting',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildMapContent(widget.briefing.importantInformation!, theme),
          ),
          isExpanded: this.isExpanded[5], // Use list to track expansion state
          canTapOnHeader: true,
        ),
      );
    }
    return panels;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: theme.cardTheme.shape,
      elevation: theme.cardTheme.elevation,
      child: Column(
        children: [
          _buildHeaderTile(theme),
          ExpansionPanelList(
            elevation: 0,
            expandedHeaderPadding: EdgeInsets.zero,
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                this.isExpanded[index] = !isExpanded; // Use list to track expansion state
              });
            },
            children: _buildExpansionPanels(theme),
          ),
          if (widget.briefing.closing.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.briefing.closing,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ),
        ],
      ),
    );
  }
}