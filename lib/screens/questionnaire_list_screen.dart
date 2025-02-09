import 'package:flutter/material.dart';

import '../models/questionnaire.dart';
import '../services/api_service.dart';
import '../widgets/main_layout.dart';
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
    final theme = Theme.of(context);
    return MainLayout(
        theme: theme,
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Questionnaires'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Text(
                'Available Surveys',
                style: theme.textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Questionnaire>>(
                future: _questionnaires,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.primaryColor,
                        ),
                      ),
                    );
                  }
      
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red[300],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Error loading questionnaires',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
      
                  final questionnaires = snapshot.data!;
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: questionnaires.length,
                    itemBuilder: (context, index) {
                      final questionnaire = questionnaires[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
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
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        questionnaire.title,
                                        style: theme.textTheme.titleLarge,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: theme.hintColor,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  questionnaire.description,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: questionnaire.responseStatus == 'completed'
                                        ? Colors.green[50]
                                        : Colors.orange[50],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    questionnaire.responseStatus == 'completed'
                                        ? 'Completed'
                                        : 'Pending',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: questionnaire.responseStatus == 'completed'
                                          ? Colors.green[700]
                                          : Colors.orange[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}