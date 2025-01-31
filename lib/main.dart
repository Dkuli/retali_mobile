import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:retali/providers/auth_provider.dart';
import 'package:retali/screens/home_screen.dart';
import 'package:retali/screens/login_screen.dart';
import 'package:retali/screens/onboarding_screens.dart';
import 'package:retali/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/shared_prefs.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Initialize notifications
  final notificationService = NotificationService();
  await notificationService.initialize();
  await SharedPrefs.init();
   WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

// Handle background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showOnboarding = prefs.getBool('showOnboarding') ?? true;
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnboarding', false);
    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        Provider<NotificationService>(create: (_) => NotificationService()),
      ],
      child: MaterialApp(
        title: 'Luggage Scanner App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
            useMaterial3: true,
            primaryColor: Color.fromARGB(255, 113, 6, 97),
          textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        ),
        home: _showOnboarding
            ? OnboardingScreen(onComplete: _completeOnboarding)
            : Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return auth.isAuthenticated ? const HomeScreen() : const LoginScreen();
                },
              ),
      ),
    );
  }
}
