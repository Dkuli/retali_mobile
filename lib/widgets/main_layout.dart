// main_layout.dart
import 'package:flutter/material.dart';
import 'package:retali/screens/ProfileScreen.dart';
import 'package:retali/screens/home_screen.dart';
import 'package:retali/screens/luggage_scan_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/questionnaire_list_screen.dart';
import 'custom_bottom_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final ThemeData theme;
  const MainLayout({
    Key? key,
    required this.child,
    required this.currentIndex,
    required this.theme,
  }) : super(key: key);

  @override
  State createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LuggageScanScreen(),
            ),
          );
        },
        backgroundColor: widget.theme.primaryColor,
        child: SvgPicture.asset(
          'assets/images/qr-scan.svg',
          width: 24,
          height: 24,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: widget.currentIndex,
        onItemSelected: _onNavItemSelected,
        theme: widget.theme,
      ),
      backgroundColor: widget.theme.scaffoldBackgroundColor,
    );
  }

  void _onNavItemSelected(int index) {
    if (index == widget.currentIndex) return;
    final newRoute = _getRouteForIndex(index);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => newRoute),
    );
  }

  Widget _getRouteForIndex(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return QuestionnaireListScreen();
      case 2:
        return const NotificationScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }
}