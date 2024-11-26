import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:retali/home_screen.dart';
import 'package:retali/luggages/screens/luggage_scan_screen.dart';
import 'package:retali/notification/notification_screen.dart';
import 'package:retali/profile/ProfileScreen.dart';
import 'package:retali/task/TaskScreen.dart';
import 'package:retali/widgets/custom_bottom_navigation_bar.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainLayout({
    Key? key,
    required this.child,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
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
        backgroundColor: const Color.fromARGB(255, 78, 29, 87),
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
      ),
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
        return const TaskScreen();
      case 2:
        return const NotificationScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }
}