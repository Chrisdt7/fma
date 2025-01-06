import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fma/services/ApiService.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  return pickedFile != null ? File(pickedFile.path) : null;
}

void showSnackBar(
  BuildContext context,
  String message, {
  bool isSuccess = false,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: colorScheme.tertiary),
    ),
    backgroundColor: isSuccess
        ? Theme.of(context).colorScheme.onSecondary
        : Theme.of(context).colorScheme.onTertiary,
    behavior: Theme.of(context).snackBarTheme.behavior,
    shape: Theme.of(context).snackBarTheme.shape,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> preloadAssetImage(BuildContext context, String? imageName) async {
  if (imageName != null && imageName.isNotEmpty) {
    await precacheImage(
      AssetImage('assets/image/profile/$imageName'),
      context,
    );
  }
}

void enable2FA() async {
  final apiService = ApiService(); // Replace with your service instance
  final result = await apiService.enableTwoFactorAuth();

  if (result != null) {
    // Show QR Code or secret key to the user
    print('2FA Enabled: ${result['qrCode'] ?? 'No QR Code provided'}');
    // Optionally, display the QR code in your app
  } else {
    print('Failed to enable 2FA');
  }
}

void disable2FA() async {
  final apiService = ApiService(); // Replace with your service instance
  final token = "123456"; // This could be fetched from a form input
  final success = await apiService.disableTwoFactorAuth(token);

  if (success) {
    print('2FA disabled successfully');
  } else {
    print('Failed to disable 2FA');
  }
}

void verify2FA() async {
  final apiService = ApiService(); // Replace with your service instance
  final token = "123456"; // User-provided token
  final success = await apiService.verifyTwoFactorAuth(token);

  if (success) {
    print('2FA verification successful');
  } else {
    print('2FA verification failed');
  }
}
