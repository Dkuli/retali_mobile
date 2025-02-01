class Questionnaire {
  final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final List<Question> questions;
  final String responseStatus;

  Questionnaire({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.questions,
    required this.responseStatus,
  });

  factory Questionnaire.fromJson(Map<String, dynamic> json) {
    return Questionnaire(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: json['status'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
      responseStatus: json['response_status'],
    );
  }
}

class Question {
  final int id;
  final String questionText;
  final String type;
  final List<String>? options;
  final bool isRequired;
  final int order;

  Question({
    required this.id,
    required this.questionText,
    required this.type,
    this.options,
    required this.isRequired,
    required this.order,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionText: json['question_text'],
      type: json['type'],
      options: json['options'] != null 
          ? List<String>.from(json['options'])
          : null,
      isRequired: json['is_required'],
      order: json['order'],
    );
  }
}