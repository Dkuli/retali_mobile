import 'package:flutter/material.dart';
import 'package:retali/shared_prefs.dart';

import '../services/api_service.dart';


class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  Map<String, dynamic>? _userData;
  static const String baseUrl = ApiService.baseUrl;

  String? get token => _token;
  String? get userId => _userId;
  Map<String, dynamic>? get userData => _userData;
  bool get isAuthenticated => _token != null;

  Future<void> login(String email, String password, String? fcmToken) async {
    try {
      final response = await ApiService.login(email, password, fcmToken);
      _token = response['data']['token'];
      _userId = response['data']['user']['id'].toString();
      _userData = response['data']['user'];
      
      // Save to shared preferences
      await SharedPrefs.saveToken(_token!);
      await SharedPrefs.saveUser(_userData!);
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await ApiService.logout();
    } finally {
      _token = null;
      _userId = null;
      _userData = null;
      await SharedPrefs.clearAll();
      notifyListeners();
    }
  }

  Future<void> loadStoredUser() async {
    _token = SharedPrefs.getToken();
    final userData = SharedPrefs.getUser();
    if (userData != null) {
      _userData = userData;
      _userId = userData['id'].toString();
    }
    notifyListeners();
  }
}