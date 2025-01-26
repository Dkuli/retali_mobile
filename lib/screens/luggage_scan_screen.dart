import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:retali/auth_provider.dart';
import 'package:retali/services/api_service.dart';
import 'package:retali/widgets/QRscannerOverlay.dart';


class LuggageScanScreen extends StatefulWidget {
  const LuggageScanScreen({super.key});

  @override
  State<LuggageScanScreen> createState() => _LuggageScanScreenState();
}

class _LuggageScanScreenState extends State<LuggageScanScreen> with SingleTickerProviderStateMixin {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanning = true;
  Position? currentPosition;
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  Future<void> _checkLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location services are disabled.')),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are permanently denied'),
            ),
          );
        }
        return;
      }

      await _getCurrentLocation();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error checking permissions: $e')),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        setState(() {
          currentPosition = position;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    }
  }



Future<void> _showLottieDialog(String lottieFile, String message) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(lottieFile, height: 150, repeat: false),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    },
  );
  await Future.delayed(const Duration(seconds: 2));
  if (mounted) Navigator.of(context).pop(); // Close the dialog
}

Future<void> _submitScanData(String qrData) async {
  if (currentPosition == null) {
    await _getCurrentLocation();
  }

  if (currentPosition == null) {
    await _showLottieDialog('assets/lottie/Animation - 1731747978549.json', 'Cannot get location');
    return;
  }

  if (mounted) {
    setState(() {
      isLoading = true;
    });
  }

  try {
    final auth = context.read<AuthProvider>();
    
    // Check if user is authenticated
    if (!auth.isAuthenticated) {
      await _showLottieDialog(
        'assets/lottie/Animation - 1731747978549.json',
        'Please login to continue'
      );
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
      return;
    }

    // Get user ID and verify it exists
    final userId = auth.userId;
    if (userId == null || userId.isEmpty) {
      await _showLottieDialog(
        'assets/lottie/Animation - 1731747978549.json',
        'User data not found. Please login again.'
      );
      await auth.logout();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
      return;
    }

    // Submit scan data
    await ApiService.storeLuggageScan(
      qrData,
      currentPosition!.latitude,
      currentPosition!.longitude,
      userId,
    );

    await _showLottieDialog(
      'assets/lottie/Animation - 1731747978549.json',
      'Luggage scan recorded successfully'
    );
    
    if (mounted) {
      setState(() {
        isScanning = true;
      });
    }
  } catch (e) {
    String errorMessage = 'An error occurred';
    if (e is ApiException) {
      errorMessage = e.message;
    }
    await _showLottieDialog('assets/lottie/Animation - 1731747978549.json', errorMessage);
  } finally {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

  @override
  void dispose() {
    _animationController.dispose();
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Luggage QR Code'),
        actions: [
        
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (BarcodeCapture barcode) {
              if (isScanning && barcode.barcodes.isNotEmpty) {
                setState(() {
                  isScanning = false;
                });
                _submitScanData(barcode.barcodes.first.rawValue!);
              }
            },
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.white)),
          FadeTransition(
            opacity: _fadeAnimation,
            child: const QRScannerOverlay(overlayColour: Colors.black54),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Align the QR code within the frame to scan',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                    
                    backgroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text(
                    'Scan Again',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                    onPressed: () {
                      setState(() {
                        isScanning = true;
                      });
                      _animationController.reset();
                      _animationController.forward();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
