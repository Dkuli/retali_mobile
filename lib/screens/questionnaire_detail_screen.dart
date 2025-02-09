import 'package:flutter/material.dart';
import '../models/questionnaire.dart';
import '../services/api_service.dart';

class QuestionnaireDetailScreen extends StatefulWidget {
  final int questionnaireId;

  QuestionnaireDetailScreen({required this.questionnaireId});

  @override
  _QuestionnaireDetailScreenState createState() =>
      _QuestionnaireDetailScreenState();
}

class _QuestionnaireDetailScreenState extends State<QuestionnaireDetailScreen> {
  late Future<Questionnaire> _questionnaire;
  final Map<int, dynamic> _answers = {};
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _questionnaire = ApiService.getQuestionnaire(widget.questionnaireId);
  }

  Future<void> _submitQuestionnaire(Questionnaire questionnaire) async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please answer all required questions'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      final answers = questionnaire.questions.map((question) {
        return {
          'question_id': question.id,
          if (question.type == 'text')
            'answer_text': _answers[question.id] ?? '',
          if (question.type == 'multiple_choice')
            'selected_options': _answers[question.id] ?? [],
        };
      }).toList();

      await ApiService.submitQuestionnaire(questionnaire.id, answers);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Questionnaire submitted successfully'),
            ],
          ),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting questionnaire: $e'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildQuestionWidget(Question question, int index) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.questionText,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildAnswerWidget(question),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerWidget(Question question) {
    final theme = Theme.of(context);
    switch (question.type) {
      case 'text':
        return TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter your answer',
          ),
          maxLines: 3,
          validator: (value) =>
              value?.isEmpty == true ? 'Please answer this question' : null,
          onChanged: (value) => _answers[question.id] = value,
        );

      case 'multiple_choice':
        return Column(
          children: question.options!.map((option) {
            return Container(
              margin: EdgeInsets.only(bottom: 8),
              child: CheckboxListTile(
                title: Text(option, style: theme.textTheme.bodyMedium),
                value: (_answers[question.id] ?? []).contains(option),
                activeColor: theme.primaryColor,
                checkColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onChanged: (checked) {
                  setState(() {
                    _answers[question.id] = _answers[question.id] ?? [];
                    if (checked!) {
                      _answers[question.id].add(option);
                    } else {
                      _answers[question.id].remove(option);
                    }
                  });
                },
              ),
            );
          }).toList(),
        );

      default:
        return Text(
          'Unsupported question type: ${question.type}',
          style: theme.textTheme.bodyMedium,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Survey'),
      ),
      body: FutureBuilder<Questionnaire>(
        future: _questionnaire,
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
                    'Error loading questionnaire',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          final questionnaire = snapshot.data!;
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  questionnaire.title,
                                  style: theme.textTheme.titleLarge,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  questionnaire.description,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                          ...questionnaire.questions
                              .asMap()
                              .entries
                              .map((entry) => _buildQuestionWidget(
                                    entry.value,
                                    entry.key,
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                ),
                if (questionnaire.responseStatus != 'completed')
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _submitQuestionnaire(questionnaire),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          'Submit Survey',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}