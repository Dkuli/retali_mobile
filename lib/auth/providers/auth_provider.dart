import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _userId;
  String? _userName;
  String? _userEmail;
  String? _userPhone;
  String? _avatarUrl;
  Map<String, dynamic>? _currentGroup;

  bool get isAuthenticated => _token != null;
  String? get token => _token;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userPhone => _userPhone;
  String? get avatarUrl => _avatarUrl;
  Map<String, dynamic>? get currentGroup => _currentGroup;

  static const String baseUrl = 'http://192.168.196.13:8000';

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'Success') {
          final responseData = data['data'];
          _token = responseData['token'];
          
          final user = responseData['user'];
          _userId = user['id'].toString();
          _userName = user['name'];
          _userEmail = user['email'];
          _userPhone = user['phone'];
          _avatarUrl = user['avatar_url'];
          _currentGroup = user['current_group'];
          
          notifyListeners();
        } else {
          throw Exception('Login failed: ${data['message']}');
        }
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      rethrow;
    }
  }

  void logout() {
    _token = null;
    _userId = null;
    _userName = null;
    _userEmail = null;
    _userPhone = null;
    _avatarUrl = null;
    _currentGroup = null;
    notifyListeners();
  }
}