import 'package:flutter/material.dart';
import 'package:retali/briefings_page/briefing.dart';

class BriefingPreviewCard extends StatelessWidget {
  final Briefing briefing;
  final bool isSelected;
  final VoidCallback onTap;

  const BriefingPreviewCard({
    Key? key,
    required this.briefing,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: isSelected ? 4 : 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      briefing.type,
                      style: TextStyle(
                        color: Colors.teal[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (briefing.location != null) ...[
                    SizedBox(width: 8),
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    Text(
                      briefing.location!,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 12),
              Text(
                briefing.opening,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}