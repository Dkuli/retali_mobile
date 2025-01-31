import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:retali/widgets/QRscannerOverlay.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
 // Pastikan import file QRScannerOverlay

class LuggageScanScreen extends StatefulWidget {
  const LuggageScanScreen({Key? key}) : super(key: key);

  @override
  State<LuggageScanScreen> createState() => _LuggageScanScreenState();
}

class _LuggageScanScreenState extends State<LuggageScanScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isScanning = true;
  bool isProcessing = false;
  String? errorMessage;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _processScan(String qrData) async {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
      errorMessage = null;
    });

    try {
      await controller.stop();
      setState(() => isScanning = false);

      final position = await _getCurrentLocation();
      final userId = Provider.of<AuthProvider>(context, listen: false).userId;
      if (userId == null) throw Exception('User not authenticated');

      final requestData = {
        'data': qrData,
        'tour_leader_id': userId,
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
      };

      final response = await ApiService.storeLuggageScan(
        requestData['data']!,
        double.parse(requestData['latitude']!),
        double.parse(requestData['longitude']!),
        requestData['tour_leader_id']!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scan berhasil: ${qrData.split(';')[1]}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => errorMessage = e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Koper'),
        actions: [
          if (!isScanning)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  isScanning = true;
                  errorMessage = null;
                });
                controller.start();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                MobileScanner(
                  controller: controller,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty && isScanning) {
                      final String? code = barcodes.first.rawValue;
                      if (code != null) {
                        _processScan(code);
                      }
                    }
                  },
                ),
                QRScannerOverlay(
                  overlayColour: Colors.black.withOpacity(0.5), // Sesuaikan opacity
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.black87,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isProcessing)
                  const CircularProgressIndicator()
                else if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                else
                  const Text(
                    'Arahkan kamera ke kode QR pada koper',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}