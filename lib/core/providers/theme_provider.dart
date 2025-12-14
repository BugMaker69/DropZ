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
    //39616C
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
      tertiary: Colors.green,
      tertiaryFixed: Colors.blueAccent,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      bodySmall: Styles.textStyle14Regular.copyWith(color: Colors.black87),
      bodyMedium: Styles.textStyle16Regular.copyWith(color: Colors.black87),
      bodyLarge: Styles.textStyle18Regular.copyWith(color: Colors.black87),
      titleSmall: Styles.textStyle16Medium.copyWith(color: Colors.black87),
      titleMedium: Styles.textStyle20Medium.copyWith(color: Colors.white),
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
      floatingLabelStyle: Styles.textStyle18Regular.copyWith(
        color: Colors.black87,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black87, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black87, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: kPrimaryColor, width: 2),
      ),
      labelStyle: Styles.textStyle16Regular.copyWith(color: Colors.black87),
      hintStyle: Styles.textStyle16Regular.copyWith(color: Colors.black87),
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
      tertiary: Colors.green,
      tertiaryFixed: Colors.blueAccent,
      onInverseSurface: Colors.white70,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      bodySmall: Styles.textStyle14Regular.copyWith(color: Colors.white70),
      bodyMedium: Styles.textStyle16Regular.copyWith(color: Colors.white70),
      bodyLarge: Styles.textStyle18Regular.copyWith(color: Colors.white70),
      titleSmall: Styles.textStyle16Medium.copyWith(color: Colors.white70),
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
      floatingLabelStyle: Styles.textStyle18Regular.copyWith(
        color: Colors.white70,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white70, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white70, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: kSecondaryColor, width: 2),
      ),
      labelStyle: Styles.textStyle16Regular.copyWith(color: Colors.white70),
      hintStyle: Styles.textStyle16Regular.copyWith(color: Colors.white70),
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



/*
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

  Future<void> _loadTheme() async {
    await initPrefs();
    final savedTheme = _prefs.getString('themeMode');
    if (savedTheme != null) {
      _themeMode = savedTheme == 'ThemeMode.dark'
          ? ThemeMode.dark
          : ThemeMode.light;
    } else {
      // Default to system
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  // Light Theme - مطابق للديزاين الفاتح
  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,

    // الألوان الأساسية
    primaryColor: const Color(0xff083947), // Primary أزرق غامق
    scaffoldBackgroundColor: const Color(0xffF5F5F5), // خلفية فاتحة
    canvasColor: Colors.white,

    colorScheme: ColorScheme.light(
      primary: const Color(0xff083947),
      secondary: const Color(0xffE0FE17), // Secondary أخضر ليمون
      surface: Colors.white,
      background: const Color(0xffF5F5F5),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
      error: Colors.redAccent,
    ),

    // الخطوط
    textTheme: GoogleFonts.poppinsTextTheme()
        .apply(bodyColor: Colors.black87, displayColor: Colors.black87)
        .copyWith(
          headlineLarge: Styles.textStyle45Bold.copyWith(
            color: const Color(0xff083947),
          ),
          headlineMedium: Styles.textStyle30Medium.copyWith(
            color: const Color(0xffE0FE17),
          ),
          titleLarge: Styles.textStyle24SemiBold,
          titleMedium: Styles.textStyle20Medium,
          bodyLarge: Styles.textStyle18Regular,
          bodyMedium: Styles.textStyle16Regular,
          bodySmall: Styles.textStyle14Regular,
        ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff083947),
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff083947),
        foregroundColor: Colors.white,
        textStyle: Styles.textStyle16Medium,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xffE0FE17),
        textStyle: Styles.textStyle16Regular,
      ),
    ),

    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xffE0FE17), width: 2),
      ),
      labelStyle: TextStyle(color: Colors.grey[600]),
      hintStyle: TextStyle(color: Colors.grey[400]),
    ),

    // TabBar
    tabBarTheme: const TabBarThemeData(
      labelColor: Color(0xffE0FE17),
      unselectedLabelColor: Colors.grey,
      indicatorColor: Color(0xffE0FE17),
    ),
  );

  // Dark Theme - مطابق للديزاين الداكن
  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    primaryColor: const Color(0xff083947),
    scaffoldBackgroundColor: const Color(0xff121212),
    canvasColor: const Color(0xff1E1E1E),

    colorScheme: ColorScheme.dark(
      primary: const Color(0xff083947),
      secondary: const Color(0xffE0FE17),
      surface: const Color(0xff1E1E1E),
      background: const Color(0xff121212),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white70,
      onBackground: Colors.white70,
      error: Colors.redAccent,
    ),

    textTheme: GoogleFonts.poppinsTextTheme()
        .apply(bodyColor: Colors.white70, displayColor: Colors.white70)
        .copyWith(
          headlineLarge: Styles.textStyle45Bold.copyWith(
            color: const Color(0xffE0FE17),
          ),
          headlineMedium: Styles.textStyle30Medium.copyWith(
            color: const Color(0xffE0FE17),
          ),
        ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff083947),
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff083947),
        foregroundColor: Colors.white,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: const Color(0xffE0FE17)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xff1E1E1E),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[800]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xffE0FE17), width: 2),
      ),
    ),

    tabBarTheme: const TabBarThemeData(
      labelColor: Color(0xffE0FE17),
      unselectedLabelColor: Colors.grey,
      indicatorColor: Color(0xffE0FE17),
    ),
  );
}

*/