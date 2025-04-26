import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary brand colors
  static const Color primaryColor = Color(0xFF3D5AF1);       // Deeper blue
  static const Color primaryLightColor = Color(0xFF6B7FF3);  // Lighter blue
  static const Color primaryDarkColor = Color(0xFF2A3EB1);   // Darker blue

  // Secondary colors
  static const Color secondaryColor = Color(0xFF22D39B);     // Vibrant green
  static const Color secondaryLightColor = Color(0xFF64E7BC);
  static const Color secondaryDarkColor = Color(0xFF0CA678);

  // Accent colors
  static const Color accent1 = Color(0xFFFF6B35);       // Orange for warnings
  static const Color accent2 = Color(0xFF9747FF);       // Purple for special elements

  // Text colors
  static const Color textPrimaryColor = Color(0xFF0F172A);   // Dark text
  static const Color textSecondaryColor = Color(0xFF64748B); // Medium gray text
  static const Color textLightColor = Color(0xFFFFFFFF);     // White text

  // Status colors
  static const Color successColor = Color(0xFF22D39B);        // Green for profits
  static const Color errorColor = Color(0xFFFF5C5C);          // Red for losses
  static const Color warningColor = Color(0xFFFF6B35);        // Orange for warnings
  static const Color infoColor = Color(0xFF3D5AF1);           // Blue for info

  // Background colors
  static const Color backgroundColor = Color(0xFFF9FAFC);    // Subtle light background
  static const Color surfaceColor = Color(0xFFFFFFFF);       // White surface

  // Chart colors
  static const Color profitColor = Color(0xFF22D39B);        // Green for profits
  static const Color lossColor = Color(0xFFFF5C5C);          // Red for losses
  static const Color fundValueColor = Color(0xFF3D5AF1);     // Blue for fund value

  // Get text theme with Google Fonts
  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16.0,
        color: textPrimaryColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14.0,
        color: textSecondaryColor,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12.0,
        color: textSecondaryColor,
      ),
    );
  }

  // Button themes
  static final ButtonThemeData buttonTheme = ButtonThemeData(
    buttonColor: primaryColor,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  // Input decoration theme
  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: const BorderSide(color: primaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: const BorderSide(color: primaryColor, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: const BorderSide(color: errorColor),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  );

  // Card theme
  static final CardTheme cardTheme = CardTheme(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
      side: BorderSide(color: Colors.grey.withOpacity(0.1)),
    ),
    color: surfaceColor,
  );

  // App bar theme
  static final AppBarTheme appBarTheme = const AppBarTheme(
    backgroundColor: surfaceColor,
    foregroundColor: textPrimaryColor,
    elevation: 0,
    centerTitle: false,
  );

  // Tab bar theme
  static final TabBarTheme tabBarTheme = const TabBarTheme(
    labelColor: primaryColor,
    unselectedLabelColor: textSecondaryColor,
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: primaryColor, width: 2.0),
    ),
  );

  // Bottom navigation bar theme
  static final BottomNavigationBarThemeData bottomNavigationBarTheme =
      const BottomNavigationBarThemeData(
    backgroundColor: surfaceColor,
    selectedItemColor: primaryColor,
    unselectedItemColor: textSecondaryColor,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  );

  // Elevated Button Theme
  static final ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: textLightColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
    ),
  );

  // Outlined Button Theme
  static final OutlinedButtonThemeData outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      side: BorderSide(color: primaryColor.withOpacity(0.5)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  );

  // Create the theme data
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
      onPrimary: textLightColor,
      onSecondary: textLightColor,
      onSurface: textPrimaryColor,
      onBackground: textPrimaryColor,
      onError: textLightColor,
      brightness: Brightness.light,
    ),
    textTheme: textTheme,
    buttonTheme: buttonTheme,
    inputDecorationTheme: inputDecorationTheme,
    cardTheme: cardTheme,
    appBarTheme: appBarTheme,
    tabBarTheme: tabBarTheme,
    bottomNavigationBarTheme: bottomNavigationBarTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    scaffoldBackgroundColor: backgroundColor,
  );

  // Dark theme (can be implemented later)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    // Dark theme implementation can be added later
  );
}
