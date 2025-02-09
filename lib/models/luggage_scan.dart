class LuggageScan {
  final int id;
  final String scannedAt;
  final String scannedAtHuman;
  final double latitude;
  final double longitude;
  final LuggageDetails luggage;

  LuggageScan({
    required this.id,
    required this.scannedAt,
    required this.scannedAtHuman,
    required this.latitude,
    required this.longitude,
    required this.luggage,
  });

  factory LuggageScan.fromJson(Map<String, dynamic> json) {
    return LuggageScan(
      id: json['id'],
      scannedAt: json['scanned_at'],
      scannedAtHuman: json['scanned_at_human'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      luggage: LuggageDetails.fromJson(json['luggage']),
    );
  }
}

class LuggageDetails {
  final String number;
  final String pilgrimName;
  final String group;
  final String phone;

  LuggageDetails({
    required this.number,
    required this.pilgrimName,
    required this.group,
    required this.phone,
  });

  factory LuggageDetails.fromJson(Map<String, dynamic> json) {
    return LuggageDetails(
      number: json['number'],
      pilgrimName: json['pilgrim_name'],
      group: json['group'],
      phone: json['phone'],
    );
  }
}