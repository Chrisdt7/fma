import 'package:flutter/material.dart';
import 'package:fma/templates/Themes.dart';
import 'package:fma/ui/HomePage.dart';
import 'package:fma/ui/ProfilePage.dart';
import 'package:fma/ui/ReportsPage.dart';
import 'package:fma/ui/TransactionsPage.dart';
import 'package:fma/ui/auth/LoginPage.dart';
import 'package:fma/ui/auth/RegisterPage.dart';

void main() {
  runApp(FMA());
}

class FMA extends StatefulWidget {
  @override
  _FMAState createState() => _FMAState();
}

class _FMAState extends State<FMA> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Financial Managing Apps',
      theme: isDarkMode ? darkTheme : lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => Theme(
              data: isDarkMode ? authDarkTheme : authLightTheme,
              child: LoginPage(toggleTheme: toggleTheme),
            ),
        '/register': (context) => Theme(
              data: isDarkMode ? authDarkTheme : authLightTheme,
              child: RegisterPage(toggleTheme: toggleTheme),
            ),
        '/home': (context) => HomePage(toggleTheme: toggleTheme),
        '/transactions': (context) =>
            TransactionsPage(toggleTheme: toggleTheme),
        '/reports': (context) => ReportsPage(toggleTheme: toggleTheme),
        '/profile': (context) => ProfilePage(toggleTheme: toggleTheme),
      },
    );
  }
}
