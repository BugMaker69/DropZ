import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  late SharedPreferences _prefs;

  ThemeProvider() {
    _loadTheme();
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _prefs.setString('themeMode', _themeMode.toString());
    notifyListeners();
  }

  void _loadTheme() async {
    await initPrefs();
    final savedTheme = _prefs.getString('themeMode');
    if (savedTheme != null) {
      _themeMode = savedTheme == 'ThemeMode.dark'
          ? ThemeMode.dark
          : ThemeMode.light;
      notifyListeners();
    }
  }

  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: kPrimaryColor, // اللون الأساسي (أزرق غامق)
    primaryColorLight: Colors.white,
    scaffoldBackgroundColor: Colors.grey[100], // خلفية فاتحة
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.white,
      brightness: Brightness.light,
      primary: kPrimaryColor, // #083947
      secondary: kSecondaryColor, // #E0FE17
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black87,
      error: Colors.redAccent,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      bodySmall: Styles.textStyle14Regular.copyWith(color: Colors.black87),
      bodyMedium: Styles.textStyle16Regular.copyWith(color: Colors.black87),
      bodyLarge: Styles.textStyle18Regular.copyWith(color: Colors.black87),
      titleMedium: Styles.textStyle20Medium.copyWith(color: Colors.black87),
      titleLarge: Styles.textStyle24SemiBold.copyWith(color: Colors.black87),
      displaySmall: Styles.textStyle30Medium.copyWith(color: kPriceColor),
      displayLarge: Styles.textStyle45Bold.copyWith(color: kSecondaryColor),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.white,
      titleTextStyle: Styles.textStyle20SemiBold.copyWith(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        textStyle: Styles.textStyle16Medium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kSecondaryColor,
        textStyle: Styles.textStyle16Regular,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: kPrimaryColor, width: 2),
      ),
      labelStyle: Styles.textStyle16Regular.copyWith(color: Colors.grey[600]),
      hintStyle: Styles.textStyle16Regular.copyWith(color: Colors.grey[400]),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: kSecondaryColor,
      unselectedLabelColor: Colors.grey[400],
      indicatorColor: kSecondaryColor,
      labelStyle: Styles.textStyle16Medium,
      unselectedLabelStyle: Styles.textStyle16Regular,
    ),
    useMaterial3: true,
  );

  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: kPrimaryColor,
    primaryColorLight: Colors.grey[900],
    scaffoldBackgroundColor: Colors.grey[900], // خلفية داكنة
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.grey[900]!,
      brightness: Brightness.dark,
      primary: kPrimaryColor, // #083947
      secondary: kSecondaryColor, // #E0FE17
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      surface: Colors.grey[850],
      onSurface: Colors.white70,
      error: Colors.redAccent,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      bodySmall: Styles.textStyle14Regular.copyWith(color: Colors.white70),
      bodyMedium: Styles.textStyle16Regular.copyWith(color: Colors.white70),
      bodyLarge: Styles.textStyle18Regular.copyWith(color: Colors.white70),
      titleMedium: Styles.textStyle20Medium.copyWith(color: Colors.white70),
      titleLarge: Styles.textStyle24SemiBold.copyWith(color: Colors.white70),
      displaySmall: Styles.textStyle30Medium.copyWith(color: kPriceColor),
      displayLarge: Styles.textStyle45Bold.copyWith(color: kSecondaryColor),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.white,
      titleTextStyle: Styles.textStyle20SemiBold.copyWith(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        textStyle: Styles.textStyle16Medium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kSecondaryColor,
        textStyle: Styles.textStyle16Regular,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: kSecondaryColor, width: 2),
      ),
      labelStyle: Styles.textStyle16Regular.copyWith(color: Colors.grey[400]),
      hintStyle: Styles.textStyle16Regular.copyWith(color: Colors.grey[500]),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: kSecondaryColor,
      unselectedLabelColor: Colors.grey[500],
      indicatorColor: kSecondaryColor,
      labelStyle: Styles.textStyle16Medium,
      unselectedLabelStyle: Styles.textStyle16Regular,
    ),
    useMaterial3: true,
  );
}
