// custom_bottom_navigation_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:retali/screens/home_screen.dart';
import 'package:retali/screens/luggage_scan_screen.dart';
import '../screens/ProfileScreen.dart';
import '../screens/notification_screen.dart';
import '../screens/questionnaire_list_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key, required this.selectedIndex, required this.onItemSelected, required this.theme});

  final int selectedIndex;
  final Function(int) onItemSelected;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BottomAppBar(
          notchMargin: 8,
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(context, 0, Icons.home_outlined, Icons.home, 'Beranda'),
                      _buildNavItem(context, 1, Icons.task_outlined, Icons.task, 'Tugas'),
                    ],
                  ),
                ),
                const SizedBox(width: 60), // Increased space for FAB
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(context, 2, Icons.notifications_outlined, Icons.notifications, 'Notifikasi'),
                      _buildNavItem(context, 3, Icons.person_outline, Icons.person, 'Profil'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: -30,
          child: Center(
            child: SizedBox(
              width: 56,
              height: 56,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LuggageScanScreen(),
                    ),
                  );
                },
                backgroundColor: theme.primaryColor,
                child: SvgPicture.asset(
                  'assets/images/qr-scan.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        onItemSelected(index);
        _handleNavigation(context, index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? theme.primaryColor : theme.textTheme.bodyMedium?.color,
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isSelected ? theme.primaryColor : theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>  QuestionnaireListScreen(),
          ),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const NotificationScreen(),
          ),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
        break;
    }
  }
}