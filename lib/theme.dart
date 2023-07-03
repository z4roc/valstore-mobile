import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.nunito().fontFamily,
  textTheme: const TextTheme(),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF16141a),
    centerTitle: false,
    elevation: 1,
  ),
  primaryColor: Color(0xff4655),
  scaffoldBackgroundColor: Color.fromARGB(0, 37, 37, 52).withOpacity(.5),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(50),
      backgroundColor: Color.fromARGB(255, 255, 70, 85),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
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

/*ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFF16141a),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF16141a),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(50),
      elevation: 1,
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.red,
  ),
);*/

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  void initTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool? darkMode = prefs.getBool('mode');
    if (darkMode != null) {
      themeMode = darkMode ? ThemeMode.dark : ThemeMode.light;
    }
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  toggleTheme(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class ChangeThemeButton extends StatelessWidget {
  const ChangeThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return IconButton(
      icon: Icon(
        themeProvider.isDarkMode
            ? Icons.nights_stay_rounded
            : Icons.wb_sunny_rounded,
      ),
      onPressed: () async {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('mode', !themeProvider.isDarkMode);
        provider.toggleTheme(!themeProvider.isDarkMode);
      },
    );
  }
}
