import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData twiggTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,

  // =====================
  // COLORS
  // =====================
  scaffoldBackgroundColor: const Color(0xFF0E0E0E),

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFD4AF37), // Gold accent
    onPrimary: Colors.black,
    background: Color(0xFF0E0E0E),
    surface: Color(0xFF161616), // Card surface (important)
    onSurface: Colors.white,
  ),

  // =====================
  // TYPOGRAPHY (CRITICAL)
  // =====================
  textTheme: GoogleFonts.interTextTheme(
    const TextTheme(
      // Large titles (welcome screen)
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),

      // Section headers
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),

      // Question text
      bodyLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.45,
      ),

      // Normal body
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: Color(0xFFB3B3B3),
      ),

      // Helper / captions
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFF8A8A8A),
      ),
    ),
  ),

  // =====================
  // BUTTONS
  // =====================
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFD4AF37),
      foregroundColor: Colors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF9E9E9E),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),

  // =====================
  // APP BAR
  // =====================
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
  ),

  // =====================
  // DIVIDERS / OUTLINES
  // =====================
  dividerTheme: const DividerThemeData(
    color: Color(0xFF262626),
    thickness: 1,
  ),
);
