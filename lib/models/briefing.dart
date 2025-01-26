// lib/models/briefing.dart
class Briefing {
  final String type;
  final String? location;
  final String opening;
  final String? introduction;
  final String? description;
  final Map<String, String>? jamaahPreparedness;
  final Map<String, String>? administrationCheck;
  final Map<String, String>? coordination;
  final Map<String, String>? importantInformation;
  final Map<String, String>? buildingCompact;
  final Map<String, String>? travelRules;
  final Map<String, String>? personalPreparedness;
  final Map<String, String>? worshipGuidance;
  final Map<String, String>? management;
  final String closing;

  Briefing({
    required this.type,
    this.location,
    required this.opening,
    this.introduction,
    this.description,
    this.jamaahPreparedness,
    this.administrationCheck,
    this.coordination,
    this.importantInformation,
    this.buildingCompact,
    this.travelRules,
    this.personalPreparedness,
    this.worshipGuidance,
    this.management,
    required this.closing,
  });

  factory Briefing.fromJson(Map<String, dynamic> json) {
    var content = json['content'];
    return Briefing(
      type: json['type'],
      location: json['location'],
      opening: content['opening'] ?? '',
      introduction: content['introduction'],
      description: content['description'],
      jamaahPreparedness: Map<String, String>.from(content['jamaah_preparedness'] ?? {}),
      administrationCheck: Map<String, String>.from(content['administration_check'] ?? {}),
      coordination: Map<String, String>.from(content['coordination'] ?? {}),
      importantInformation: Map<String, String>.from(content['important_information'] ?? {}),
      buildingCompact: Map<String, String>.from(content['building_compact'] ?? {}),
      travelRules: Map<String, String>.from(content['travel_rules'] ?? {}),
      personalPreparedness: Map<String, String>.from(content['personal_preparedness'] ?? {}),
      worshipGuidance: Map<String, String>.from(content['worship_guidance'] ?? {}),
      management: Map<String, String>.from(content['management'] ?? {}),
      closing: content['closing'] ?? '',
    );
  }
}