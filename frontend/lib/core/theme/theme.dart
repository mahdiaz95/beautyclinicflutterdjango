import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class AppTheme {
  static const Color lightBlue =
      Color.fromARGB(255, 220, 235, 250); // آبی بسیار روشن
  static const Color blueAccent =
      Color.fromARGB(255, 100, 149, 237); // cornflower blue
  static const Color blueFocused =
      Color.fromARGB(255, 65, 105, 225); // royal blue

  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(12),
      );

  static final brightThemeMode = ThemeData.light().copyWith(
    primaryColor: blueAccent,
    scaffoldBackgroundColor: lightBlue,
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Vazirmatn',
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      enabledBorder: _border(blueAccent),
      focusedBorder: _border(blueFocused),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: blueAccent,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightBlue,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black54,
      type: BottomNavigationBarType.fixed,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final darkThemeMode = ThemeData.dark().copyWith(
    primaryColor: blueAccent,
    scaffoldBackgroundColor: const Color.fromARGB(255, 20, 22, 30),
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Vazirmatn',
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      enabledBorder: _border(blueAccent),
      focusedBorder: _border(blueFocused),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color.fromARGB(255, 30, 33, 45),
      foregroundColor: blueAccent,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 30, 33, 45),
      selectedItemColor: Color.fromARGB(255, 135, 206, 250), // light sky blue
      unselectedItemColor: Colors.white54,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
