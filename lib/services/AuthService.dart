import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logout Successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
