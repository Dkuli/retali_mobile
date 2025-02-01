
import 'package:flutter/material.dart';

import '../models/questionnaire.dart';
import '../services/api_service.dart';
import 'questionnaire_detail_screen.dart';

class QuestionnaireListScreen extends StatefulWidget {
  @override
  _QuestionnaireListScreenState createState() => _QuestionnaireListScreenState();
}

class _QuestionnaireListScreenState extends State<QuestionnaireListScreen> {
  late Future<List<Questionnaire>> _questionnaires;

  @override
  void initState() {
    super.initState();
    _questionnaires = ApiService.getQuestionnaires();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionnaires'),
      ),
      body: FutureBuilder<List<Questionnaire>>(
        future: _questionnaires,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final questionnaires = snapshot.data!;
          return ListView.builder(
            itemCount: questionnaires.length,
            itemBuilder: (context, index) {
              final questionnaire = questionnaires[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(questionnaire.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(questionnaire.description),
                      SizedBox(height: 4),
                      Text(
                        'Status: ${questionnaire.responseStatus}',
                        style: TextStyle(
                          color: questionnaire.responseStatus == 'completed'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionnaireDetailScreen(
                          questionnaireId: questionnaire.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}