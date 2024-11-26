import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _tourLeaderId;
  String? _tourLeaderName;
  String? _tourLeaderEmail;
  String? profilePhotoUrl;

  bool get isAuthenticated => _token != null;
  String? get token => _token;
  String? get tourLeaderId => _tourLeaderId;
  String? get tourLeaderName => _tourLeaderName;
  String? get tourLeaderEmail => _tourLeaderEmail;

  Map<String, dynamic>? tourLeader;

  static const String baseUrl = 'http://192.168.190.13:8000';

  get profile_photo_url => null;

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['access_token'];
        
        // Mengambil 'tour_leader' sebagai objek
        if (data.containsKey('tour_leader')) {
          final tourLeader = data['tour_leader'];
          _tourLeaderId = tourLeader['id'].toString();  // Ambil ID dari 'tour_leader' object
          _tourLeaderName = tourLeader['name']; 
          _tourLeaderEmail = tourLeader['email']; // Ambil email dari 'tour_leader' object
          profilePhotoUrl = tourLeader['profile_photo_url'];
           
           // Ambil nama dari 'tour_leader' object
        } else {
          throw Exception('tour_leader data not found in login response');
        }
        
        notifyListeners();
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      rethrow;
    }
  }

  void logout() {
    _token = null;
    _tourLeaderId = null;
    _tourLeaderName = null;
    _tourLeaderEmail = null;
    notifyListeners();
  }
}