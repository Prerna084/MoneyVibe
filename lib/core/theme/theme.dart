import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final twiggTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0F0F0F), // Near black
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFD4AF37), // The Signature Gold
    onPrimary: Colors.black,
    surface: Color(0xFF1A1A1A),
    onSurface: Colors.white,
  ),
  textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
  useMaterial3: true,
);
