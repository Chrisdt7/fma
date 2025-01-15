import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fma/services/ApiService.dart';
import 'package:fma/templates/AppLocalization.dart';
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

Future<void> sendEmail2FA(BuildContext context) async {
  final result = await ApiService().sendEmail2FA();

  if (result != null && result.containsKey('message')) {
    showSnackBar(context,
        AppLocalizations.of(context).translate("snackbarSuccessSendEmail"),
        isSuccess: true);
  } else if (result != null && result.containsKey('error')) {
    showSnackBar(context,
        AppLocalizations.of(context).translate("snackbarFailedSendEmail"));
  } else {
    showSnackBar(context, 'Unexpected error occurred.');
  }
}

void showEmailVerificationDialog(
    BuildContext context, Function(bool) onToggle) {
  final TextEditingController token2FAController = TextEditingController();

  void verify2FA(BuildContext context, String code) async {
    try {
      final result =
          await ApiService().verify2FA(code); // Implement this in ApiService
      if (result != null &&
          result.containsKey('success') &&
          result['success']) {
        final enableResult = await ApiService().enable2FA();
        if (enableResult != null && enableResult.containsKey('user')) {
          Navigator.of(context).pop(); // Close the dialog
          showSnackBar(
              context,
              AppLocalizations.of(context)
                  .translate("snackbarSuccessEnable2FA"),
              isSuccess: true);
          onToggle(enableResult['user']['isTwoFactorEnabled'] ?? false);
        } else {
          showSnackBar(
              context,
              AppLocalizations.of(context)
                  .translate("snackbarFailedEnable2FA"));
        }
      } else {
        showSnackBar(context,
            AppLocalizations.of(context).translate("snackbarInvalidCode"));
      }
    } catch (e) {
      showSnackBar(context, 'Error verifying 2FA: $e');
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      final localizations = AppLocalizations.of(context);

      return AlertDialog(
        title: Text(
          localizations.translate("text-helpers-title"),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(localizations.translate("text-helpers-sent-email")),
              const SizedBox(height: 16),
              TextField(
                controller: token2FAController,
                decoration: InputDecoration(
                  labelText:
                      localizations.translate("text-helpers-label-enter-code"),
                ),
              ),
              TextButton(
                onPressed: () =>
                    sendEmail2FA(context), // Resend email functionality
                child: Text(
                    localizations.translate("text-helpers-label-resend-email")),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.translate("text-cancel")),
          ),
          TextButton(
            onPressed: () {
              final code = token2FAController.text.trim();
              if (code.isNotEmpty) {
                verify2FA(context, code);
              } else {
                showSnackBar(
                    context, localizations.translate("snackbarRequiredCode"));
              }
            },
            child: Text(localizations.translate("text-helpers-label-verify")),
          ),
        ],
      );
    },
  );
}

// Future<void> toggle2FA(bool isEnabled, BuildContext context) async {
//   try {
//     if (isEnabled) {
//       await disable2FA();
//       showSnackBar(context, '2FA Disabled', isSuccess: true);
//     } else {
//       await enable2FA();
//       showSnackBar(context, '2FA Enabled', isSuccess: true);
//     }
//   } catch (e) {
//     showSnackBar(context, 'Failed to toggle 2FA: $e');
//   }
// }
