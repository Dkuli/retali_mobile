import 'package:flutter/material.dart';

class DetailMasalahScreen extends StatelessWidget {
  final String title;
  final Map<String, dynamic> problemData;
  final String heroTag;

  const DetailMasalahScreen({
    Key? key,
    required this.title,
    required this.problemData,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: problemData.length,
        itemBuilder: (context, index) {
          final key = problemData.keys.elementAt(index);
          final value = problemData[key];
          
          if (key == 'image') {
            return Hero(
              tag: heroTag,
              child: Image.asset(
                value as String,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          }
          
          if (value is Map) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ExpansionTile(
                title: Text(key),
                children: value.entries.map<Widget>((entry) {
                  return ListTile(
                    title: Text(entry.key),
                    subtitle: Text(entry.value),
                  );
                }).toList(),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
