import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class LocationService {
  static LocationService? _instance;
  Timer? _timer;
  bool _isTracking = false;
  static const String _trackingKey = 'tracking_enabled';

  LocationService._internal() {
    _initializeTracking();
  }

  static LocationService getInstance() {
    _instance ??= LocationService._internal();
    return _instance!;
  }

  Future<void> _initializeTracking() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_trackingKey) ?? false) {
      await startTracking();
    }
  }

  bool get isTracking => _isTracking;

  Future<void> startTracking() async {
    if (_isTracking) return;
    
    try {
      await _checkPermissions();
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
        await _sendLocation();
      });
      _isTracking = true;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_trackingKey, true);
    } catch (e) {
      print("Failed to start tracking: $e");
      _isTracking = false;
      rethrow;
    }
  }

  Future<void> stopTracking() async {
    _timer?.cancel();
    _timer = null;
    _isTracking = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_trackingKey, false);
  }

  Future<void> _checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied");
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied");
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled");
    }
  }

  Future<void> _sendLocation() async {
    Position position = await _getCurrentPosition();
    Map<String, dynamic> locationData = {
      "latitude": position.latitude,
      "longitude": position.longitude,
      "accuracy": position.accuracy,
      "speed": position.speed,
      "battery_level": 100, // Tambahkan cara ambil baterai jika diperlukan
    };

    try {
      await ApiService.storeLocation(locationData);
    } catch (e) {
      print("Gagal mengirim lokasi: $e");
    }
  }

  Future<Position> _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Izin lokasi ditolak secara permanen.");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
