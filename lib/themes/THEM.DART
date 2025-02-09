import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  // Base Colors - Travel Inspired
  primaryColor: const Color(0xFF85205D), // Dominan ungu maroon dari logo
  primaryColorLight: const Color(0xBD3A84),  // Teal (Adventure)
  primaryColorDark: const Color(0x512858),   // Dark Navy
  hintColor: const Color(0xBD3A84),	// Coral Orange (Energy)
  scaffoldBackgroundColor: const Color(0xFFF7FAFC),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF85205D),
    secondary: Color(0xBD3A84),
    tertiary: Color(0xFF38B2AC),
    surface: Colors.white,
    background: Color(0xFFF7FAFC),
    error: Color(0xFFE53E3E),
  ),
  // App Bar Theme (Travel Agency Style)
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    elevation: 2,
    centerTitle: true,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: const Color.fromARGB(255, 0, 0, 0),
      fontWeight: FontWeight.w700,
      fontSize: 20,
      fontFamily: 'Roboto',
      letterSpacing: 1.2,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(15),
      ),
    ),
  ),
  // Card Theme (Travel Cards)
  cardTheme: CardTheme(
    elevation: 3,
    color: Colors.white,
    shadowColor: Colors.blueGrey.withOpacity(0.2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    margin: const EdgeInsets.all(8),
    surfaceTintColor: Colors.white,
  ),
  // Input Decoration (Booking Form Style)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFF38B2AC),
        width: 2,
      ),
    ),
    labelStyle: const TextStyle(color: Color(0xFF4A5568)),
    hintStyle: TextStyle(
      color: Colors.grey[500],
      fontSize: 16,
    ),
  ),
  // Text Theme
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1A365D),
      fontFamily: 'Roboto',
    ),
    displayMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Color(0xFF2A4F6B),
      fontFamily: 'Roboto',
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFF2A4F6B),
      letterSpacing: 0.5,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Color(0xFF4A5568),
      height: 1.5,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
  // Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF85205D),
      foregroundColor: Colors.white,
      elevation: 3,
      shadowColor: const Color(0xFF85205D).withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ),
  // Icon Theme
  iconTheme: const IconThemeData(
    color: Color(0xFF2A4F6B),
    size: 24,
  ),
  // Divider Theme
  dividerTheme: DividerThemeData(
    color: Colors.grey[300],
    thickness: 1,
    space: 24,
  ),
  // Floating Action Button Theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF85205D),
    foregroundColor: Colors.white,
    elevation: 4,
    shape: CircleBorder(),
  ),
);