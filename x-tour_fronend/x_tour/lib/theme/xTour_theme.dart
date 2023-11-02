import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class XTourTheme {
  const XTourTheme();
  final Color primaryDarkColor = const Color(0xFF18D9A3);
  final Color secondaryDarkColor = const Color(0xFF34C3A2);
  final Color scaffoldDarkBackgroundColor = const Color(0xFF171B34);
  final Color cardDarkBackgroundColor = const Color(0xFF191C32);
  final Color textDarkPrimaryColor = const Color.fromARGB(255, 52, 195, 162);
  final Color textDarkSecondaryColor = const Color.fromARGB(255, 250, 246, 244);

  final Color primaryLightColor = const Color(0xFF18D9A3);
  final Color secondaryLightColor = const Color(0xFF34C3A2);
  final Color scaffoldLightBackgroundColor = const Color(0xFFF6F7F8);
  final Color cardLightBackgroundColor = const Color(0xFFFFFFFF);
  final Color textLightPrimaryColor = const Color.fromARGB(255, 25, 28, 50);
  final Color textLightSecondaryColor = const Color.fromARGB(205, 25, 28, 50);

  ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryLightColor,
      scaffoldBackgroundColor: scaffoldLightBackgroundColor,
      cardColor: cardLightBackgroundColor,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Color.fromARGB(255, 25, 28, 50),
        backgroundColor: Color(0xFF34C3A2),
      ),
      iconTheme: IconThemeData(color: primaryLightColor),
      listTileTheme: ListTileThemeData(iconColor: primaryLightColor),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryDarkColor, // Sets the primary color for buttons
        textTheme: ButtonTextTheme
            .primary, // Sets the text color of buttons to the primary color
        splashColor:
            secondaryDarkColor, // Sets the splash color of buttons to the secondary color
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: primaryDarkColor,
        foregroundColor: cardDarkBackgroundColor,
        disabledBackgroundColor: secondaryDarkColor,
      )),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Color(0xFF34C3A2),
        backgroundColor: Color(0xFFFFFFFF),
        unselectedItemColor: Color.fromARGB(255, 26, 33, 31),
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.spaceGrotesk(
          fontSize: 21.0,
          fontWeight: FontWeight.bold,
          color: textLightPrimaryColor,
        ),
        bodyMedium: GoogleFonts.spaceGrotesk(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: textLightSecondaryColor,
        ),
        bodySmall: GoogleFonts.spaceGrotesk(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: textLightSecondaryColor,
        ),
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: textLightPrimaryColor,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 21.0,
          fontWeight: FontWeight.w700,
          color: textLightSecondaryColor,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: textLightPrimaryColor,
        ),
      ),
    );
  }

  ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryDarkColor,
      scaffoldBackgroundColor: scaffoldDarkBackgroundColor,
      cardColor: cardDarkBackgroundColor,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Color(0xFF191C32),
        backgroundColor: Color(0xFF34C3A2),
      ),
      iconTheme: IconThemeData(color: primaryLightColor),
      listTileTheme: ListTileThemeData(iconColor: primaryLightColor),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryDarkColor, // Sets the primary color for buttons
        textTheme: ButtonTextTheme
            .primary, // Sets the text color of buttons to the primary color
        splashColor:
            secondaryDarkColor, // Sets the splash color of buttons to the secondary color
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: primaryDarkColor,
        foregroundColor: cardDarkBackgroundColor,
        disabledBackgroundColor: secondaryDarkColor,
      )),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Color(0xFF34C3A2),
        backgroundColor:  Color(0xFF191C32),
        unselectedItemColor: Color(0xFF34C3A2),
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.spaceGrotesk(
          fontSize: 21.0,
          fontWeight: FontWeight.bold,
          color: textDarkPrimaryColor,
        ),
        bodyMedium: GoogleFonts.spaceGrotesk(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: textDarkSecondaryColor,
        ),
        bodySmall: GoogleFonts.spaceGrotesk(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: textDarkSecondaryColor,
        ),
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: textDarkPrimaryColor,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 21.0,
          fontWeight: FontWeight.w700,
          color: textDarkSecondaryColor,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: textDarkPrimaryColor,
        ),
      ),
    );
  }
}
