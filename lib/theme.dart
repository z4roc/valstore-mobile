import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeData = ThemeData(
  useMaterial3: true,
  primaryTextTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle( 
      fontSize: 15,
      fontWeight: FontWeight.w700,
    ),
  ),
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.nunito().fontFamily,
  textTheme: const TextTheme(),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF16141a),
    centerTitle: false,
    elevation: 1,
  ),
  primaryColor: const Color(0x00ff4655),
  scaffoldBackgroundColor: const Color.fromARGB(0, 37, 37, 52).withOpacity(.5),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(50),
      backgroundColor: const Color.fromARGB(255, 255, 70, 85),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: Colors.white,
      ),
      elevation: 2,
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFF16141a),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color.fromARGB(255, 255, 70, 85),
  ),
);
