import 'package:flutter/material.dart';

final TextTheme lightTextTheme = TextTheme(
  displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
  displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
  headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
  headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
  headlineSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  titleLarge:
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Light theme title
  titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
  bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
  bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
  bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
  labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
);

final TextTheme darkTextTheme = TextTheme(
  displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
  displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
  headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
  headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
  headlineSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  titleLarge:
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Dark theme title
  titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
  bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
  bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
  bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
  labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Colors.black,
  onPrimary: Color.fromARGB(255, 0, 174, 255),
  secondary: Colors.grey,
  onSecondary: Color.fromARGB(255, 0, 255, 8),
  tertiary: Colors.white,
  onTertiary: Colors.red,
  error: Colors.red,
  onError: Colors.white,
  background: Colors.white,
  onBackground: Colors.black,
  surface: Colors.black26,
  onSurface: Colors.black,
  outline: Colors.black45,
  primaryContainer: Colors.white10,
  onPrimaryContainer: Color.fromARGB(255, 1, 43, 63),
  onSecondaryContainer: Colors.green,
  outlineVariant: Color.fromRGBO(233, 213, 38, 0.784),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Colors.white70,
  onPrimary: Color.fromARGB(211, 12, 3, 145),
  secondary: Colors.grey,
  onSecondary: Color.fromARGB(170, 0, 255, 8),
  tertiary: Colors.black,
  onTertiary: Color.fromARGB(170, 244, 67, 54),
  error: Color.fromARGB(255, 65, 7, 3),
  onError: Colors.black,
  background: Colors.black,
  onBackground: Colors.white,
  surface: Colors.white30,
  onSurface: Colors.white54,
  outline: Colors.white30,
  primaryContainer: Color.fromARGB(255, 1, 43, 63),
  onPrimaryContainer: Colors.lightBlue,
  onSecondaryContainer: Colors.greenAccent,
  outlineVariant: Colors.grey,
);

class AuthGradientTheme extends ThemeExtension<AuthGradientTheme> {
  final LinearGradient authBackgroundGradient;

  AuthGradientTheme({required this.authBackgroundGradient});

  @override
  AuthGradientTheme copyWith({
    LinearGradient? authBackgroundGradient,
  }) {
    return AuthGradientTheme(
      authBackgroundGradient:
          authBackgroundGradient ?? this.authBackgroundGradient,
    );
  }

  @override
  AuthGradientTheme lerp(ThemeExtension<AuthGradientTheme>? other, double t) {
    if (other is! AuthGradientTheme) return this;
    return AuthGradientTheme(
      authBackgroundGradient: LinearGradient.lerp(
          authBackgroundGradient, other.authBackgroundGradient, t)!,
    );
  }
}

class GradientTheme extends ThemeExtension<GradientTheme> {
  final LinearGradient backgroundGradient;
  final LinearGradient appBarGradient;
  final LinearGradient bottomNavBarGradient;

  GradientTheme(
      {required this.backgroundGradient,
      required this.appBarGradient,
      required this.bottomNavBarGradient});

  @override
  GradientTheme copyWith({
    LinearGradient? backgroundGradient,
    LinearGradient? appBarGradient,
    LinearGradient? bottomNavBarGradient,
  }) {
    return GradientTheme(
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      appBarGradient: appBarGradient ?? this.appBarGradient,
      bottomNavBarGradient: bottomNavBarGradient ?? this.bottomNavBarGradient,
    );
  }

  @override
  GradientTheme lerp(ThemeExtension<GradientTheme>? other, double t) {
    if (other is! GradientTheme) return this;
    return GradientTheme(
      backgroundGradient:
          LinearGradient.lerp(backgroundGradient, other.backgroundGradient, t)!,
      appBarGradient:
          LinearGradient.lerp(appBarGradient, other.appBarGradient, t)!,
      bottomNavBarGradient: LinearGradient.lerp(
          bottomNavBarGradient, other.bottomNavBarGradient, t)!,
    );
  }
}

final ThemeData authLightTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  textTheme: lightTextTheme,
  colorScheme: lightColorScheme,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.green,
    contentTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    behavior: SnackBarBehavior.floating,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: lightColorScheme.primaryContainer,
      foregroundColor: lightColorScheme.onPrimaryContainer,
      elevation: 5,
      shadowColor: lightColorScheme.onPrimaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  extensions: [
    AuthGradientTheme(
      authBackgroundGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color.fromARGB(255, 74, 219, 219), Color(0xFFCBF1F5)],
      ),
    ),
  ],
);

final ThemeData authDarkTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  textTheme: darkTextTheme,
  colorScheme: darkColorScheme,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.greenAccent,
    contentTextStyle: TextStyle(
      color: Colors.black.withOpacity(0.8),
      fontWeight: FontWeight.bold,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    behavior: SnackBarBehavior.floating,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: darkColorScheme.primaryContainer,
      foregroundColor: darkColorScheme.onPrimaryContainer,
      elevation: 5,
      shadowColor: darkColorScheme.onPrimaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  extensions: [
    AuthGradientTheme(
      authBackgroundGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color.fromARGB(255, 10, 1, 83), Color(0x010008)],
      ),
    ),
  ],
);

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  textTheme: lightTextTheme,
  colorScheme: lightColorScheme,
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: lightColorScheme.primary,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: lightColorScheme.onPrimary,
    unselectedItemColor: lightColorScheme.primary,
  ),
  extensions: [
    GradientTheme(
      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, Colors.lightBlue],
      ),
      appBarGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.lightBlue, Colors.white],
      ),
      bottomNavBarGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.lightBlue, Colors.white],
      ),
    ),
  ],
);

final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  textTheme: darkTextTheme,
  colorScheme: darkColorScheme,
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: darkColorScheme.primary,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: darkColorScheme.onPrimary,
    unselectedItemColor: darkColorScheme.primary,
  ),
  extensions: [
    GradientTheme(
      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.black, Color.fromARGB(255, 5, 7, 48)],
      ),
      appBarGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color.fromARGB(255, 5, 7, 48), Colors.black],
      ),
      bottomNavBarGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color.fromARGB(255, 5, 7, 48), Colors.black],
      ),
    ),
  ],
);
