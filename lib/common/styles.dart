import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xFF344955);
const subPrimaryColor = Color(0xFF4A6572);
const secondaryColor = Color(0xFFF9AA33);
const textColor = Color(0xFF232F34);
const backgroundColor = Color(0xFFFFFFFF);

final TextTheme appTextTheme = TextTheme(
  displayLarge: GoogleFonts.workSans(
      fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  displayMedium: GoogleFonts.workSans(
      fontSize: 60, fontWeight: FontWeight.w600, letterSpacing: -0.5),
  displaySmall: GoogleFonts.workSans(fontSize: 48, fontWeight: FontWeight.w600),
  headlineMedium: GoogleFonts.workSans(
      fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headlineSmall: GoogleFonts.workSans(fontSize: 24, fontWeight: FontWeight.w700),
  titleLarge: GoogleFonts.workSans(
      fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleMedium: GoogleFonts.workSans(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  titleSmall: GoogleFonts.workSans(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyLarge: GoogleFonts.workSans(
      fontSize: 18, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyMedium: GoogleFonts.workSans(
      fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  labelLarge: GoogleFonts.workSans(
      fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.25),
  bodySmall: GoogleFonts.workSans(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  labelSmall: GoogleFonts.workSans(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);