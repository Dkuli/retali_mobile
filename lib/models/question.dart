// lib/models/question.dart
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
