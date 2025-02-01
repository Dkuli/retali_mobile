import 'package:flutter/material.dart';

import '../models/questionnaire.dart';
import '../services/api_service.dart';

class QuestionnaireDetailScreen extends StatefulWidget {
  final int questionnaireId;

  QuestionnaireDetailScreen({required this.questionnaireId});

  @override
  _QuestionnaireDetailScreenState createState() => _QuestionnaireDetailScreenState();
}

class _QuestionnaireDetailScreenState extends State<QuestionnaireDetailScreen> {
  late Future<Questionnaire> _questionnaire;
  final Map<int, dynamic> _answers = {};

  @override
  void initState() {
    super.initState();
    _questionnaire = ApiService.getQuestionnaire(widget.questionnaireId);
  }

  Future<void> _submitQuestionnaire(Questionnaire questionnaire) async {
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
        SnackBar(content: Text('Questionnaire submitted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting questionnaire: $e')),
      );
    }
  }

  Widget _buildQuestionWidget(Question question) {
    switch (question.type) {
      case 'text':
        return TextFormField(
          decoration: InputDecoration(
            labelText: question.questionText,
            hintText: 'Enter your answer',
          ),
          onChanged: (value) => _answers[question.id] = value,
        );
      
      case 'multiple_choice':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.questionText),
            ...question.options!.map((option) => CheckboxListTile(
              title: Text(option),
              value: (_answers[question.id] ?? []).contains(option),
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
            )),
          ],
        );
      
      default:
        return Text('Unsupported question type: ${question.type}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionnaire'),
      ),
      body: FutureBuilder<Questionnaire>(
        future: _questionnaire,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final questionnaire = snapshot.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questionnaire.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 8),
                Text(questionnaire.description),
                SizedBox(height: 24),
                ...questionnaire.questions
                    .map((q) => Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: _buildQuestionWidget(q),
                        ))
                    .toList(),
                SizedBox(height: 16),
                if (questionnaire.responseStatus != 'completed')
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _submitQuestionnaire(questionnaire),
                      child: Text('Submit'),
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