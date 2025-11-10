import 'package:flutter/material.dart';

final ColorScheme mistColors = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 217, 204, 238), // same as your previous ARGB
    brightness: Brightness.light,
  );
  
final ThemeData mistPurpleTheme = ThemeData(
  useMaterial3: true,
  colorScheme: mistColors,
  primaryColor: mistColors.primary, // reuse from ColorScheme
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: mistColors.primary, // reuse
    foregroundColor: mistColors.onPrimary, // text color on primary
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF333333)),
    bodyMedium: TextStyle(color: Color(0xFF666666)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: mistColors.primary, // reuse
    foregroundColor: mistColors.onPrimary, // ensure contrast
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    // fillColor: const Color(0xFFF2F6F7),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: Color(0xFF666666)),
  ),
  // cardTheme: CardTheme(
  //   color: mistColors.onSurface, // 浅蓝/紫色容器色
  //   shadowColor: Colors.grey.shade100,
  //   elevation: 4,
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(16),
  //   ),
  // ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    },
  ),
);

