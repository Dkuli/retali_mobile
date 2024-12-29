// lib/services/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:retali/models/carousel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.196.13:8000/api/v1';
  static const String _tokenKey = 'auth_token';
  
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  static Future<dynamic> handleResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 401:
        throw UnauthorizedException();
      case 403:
        throw ForbiddenException();
      case 404:
        throw NotFoundException();
      case 422:
        throw ValidationException(json.decode(response.body));
      case 500:
      default:
        throw ServerException();
    }
  }

  // Auth APIs
  static Future<Map<String, dynamic>> login(String email, String password, String? fcmToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: json.encode({
          'email': email,
          'password': password,
          'fcm_token': fcmToken,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      
      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        if (data['status'] == 'Success' && data['data']['token'] != null) {
          await setToken(data['data']['token']);
          return data;
        } else {
          throw ApiException(data['message'] ?? 'Authentication failed');
        }
      } else {
        throw ApiException(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(e.toString());
    }
  }

  static Future<void> logout() async {
    final headers = await _getHeaders();
    await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: headers,
    );
    await clearToken();
  }

  // Profile APIs
  static Future<Future> getProfile() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: headers,
    );
    return handleResponse(response);
  }

  static Future<Future> updateProfile(Map<String, dynamic> data, {File? avatar}) async {
    final headers = await _getHeaders();
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/profile'))
      ..headers.addAll(headers)
      ..fields.addAll(
        data.map((key, value) => MapEntry(key, value.toString())),
      );

    if (avatar != null) {
      request.files.add(
        await http.MultipartFile.fromPath('avatar', avatar.path),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return handleResponse(response);
  }

  static Future<void> updateFcmToken(String fcmToken) async {
    final headers = await _getHeaders();
    await http.post(
      Uri.parse('$baseUrl/fcm-token'),
      headers: headers,
      body: json.encode({'fcm_token': fcmToken}),
    );
  }

  // Group APIs
  static Future<Future> getCurrentGroup() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/group/current'),
      headers: headers,
    );
    return handleResponse(response);
  }

  static Future<List<dynamic>> getPilgrims() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/group/pilgrims'),
      headers: headers,
    );
    final data = await handleResponse(response);
    return data['data'];
  }

  static Future<List<dynamic>> getSchedule() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/group/schedule'),
      headers: headers,
    );
    final data = await handleResponse(response);
    return data['data'];
  }

  // Location APIs
  static Future<Future> storeLocation(Map<String, dynamic> locationData) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/locations'),
      headers: headers,
      body: json.encode(locationData),
    );
    return handleResponse(response);
  }

  // Task APIs
  static Future<List<dynamic>> getTasks() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/tasks'),
      headers: headers,
    );
    final data = await handleResponse(response);
    return data['data'];
  }

  static Future<Future> submitTaskResponse(Map<String, dynamic> responseData) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/tasks/response'),
      headers: headers,
      body: json.encode(responseData),
    );
    return handleResponse(response);
  }

  // Content APIs
  static Future<List<dynamic>> getContents() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/contents'),
      headers: headers,
    );
    final data = await handleResponse(response);
    return data['data'];
  }

  static Future<Future> uploadContent(
    String title,
    String description,
    String type,
    File file,
  ) async {
    final headers = await _getHeaders();
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/contents'))
      ..headers.addAll(headers)
      ..fields.addAll({
        'title': title,
        'description': description,
        'type': type,
      })
      ..files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return handleResponse(response);
  }

  // Notification APIs
  static Future<List<dynamic>> getNotifications() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/notifications'),
      headers: headers,
    );
    final data = await handleResponse(response);
    return data['data'];
  }

  static Future<Future> markNotificationAsRead(int notificationId) async {
    final headers = await _getHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/notifications/$notificationId'),
      headers: headers,
    );
    return handleResponse(response);
  }

  // Carousel APIs
  static Future<List<Carousel>> getCarousels() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/carousels'),
      headers: headers,
    );
    final data = await handleResponse(response);
    return (data['data'] as List).map((item) => Carousel.fromJson(item)).toList();
  }

  // Luggage Scan APIs
  static Future<dynamic> storeLuggageScan(
    String qrData,
    double latitude,
    double longitude,
    String userId,
  ) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/luggage_scans'),
      headers: headers,
      body: json.encode({
        'data': qrData,
        'user_id': userId,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );
    return handleResponse(response);
  }
}

// Custom exceptions
class ApiException implements Exception {
  final String message;
  
  ApiException(this.message);
  
  @override
  String toString() => message;
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super('Unauthorized');
}

class ForbiddenException extends ApiException {
  ForbiddenException() : super('Forbidden');
}

class NotFoundException extends ApiException {
  NotFoundException() : super('Not found');
}

class ValidationException extends ApiException {
  final Map<String, dynamic> errors;
  ValidationException(this.errors) : super('Validation failed');
}

class ServerException extends ApiException {
  ServerException() : super('Server error');
}
