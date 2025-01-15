import 'package:flutter/material.dart';
import 'package:fma/services/ApiService.dart';
import 'package:fma/services/Helpers.dart';
import 'package:fma/templates/AppLocalization.dart';

Future<void> showChangePasswordDialog(
  BuildContext context,
  FocusNode passwordFocusNode,
  FocusNode newPasswordFocusNode,
  FocusNode confirmPasswordFocusNode,
  Function refreshUser,
) async {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  final colorScheme = theme.colorScheme;
  final localizations = AppLocalizations.of(context);

  return showDialog(
    context: context,
    builder: (context) {
      // Local states for password visibility
      bool isCurrentPasswordVisible = false;
      bool isNewPasswordVisible = false;
      bool isConfirmPasswordVisible = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            surfaceTintColor: colorScheme.surface,
            title: Text(
              localizations.translate("ChangePassword-label-title"),
              textAlign: TextAlign.center,
              style: textTheme.titleLarge
                  ?.copyWith(color: colorScheme.tertiary.withAlpha(255)),
            ),
            backgroundColor: theme.dialogBackgroundColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: currentPasswordController,
                  focusNode: passwordFocusNode,
                  style: TextStyle(
                    color: passwordFocusNode.hasFocus ||
                            currentPasswordController.text.isNotEmpty
                        ? colorScheme.tertiary
                        : colorScheme.onSurface,
                  ),
                  obscureText: !isCurrentPasswordVisible,
                  decoration: InputDecoration(
                    labelText:
                        localizations.translate("label-current-password"),
                    hintText: localizations.translate("hint-current-password"),
                    icon: Icon(Icons.lock_outline),
                    iconColor: colorScheme.tertiary.withAlpha(200),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorScheme.tertiary),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorScheme.tertiary),
                    ),
                    floatingLabelStyle: TextStyle(color: colorScheme.tertiary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isCurrentPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          isCurrentPasswordVisible = !isCurrentPasswordVisible;
                        });
                      },
                    ),
                  ),
                  autofocus: true,
                  validator: (value) => value == null || value.isEmpty
                      ? localizations
                          .translate("snackbarRequiredCurrentPassword")
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: !isNewPasswordVisible,
                  focusNode: newPasswordFocusNode,
                  style: TextStyle(
                    color: newPasswordFocusNode.hasFocus ||
                            newPasswordController.text.isNotEmpty
                        ? colorScheme.tertiary
                        : colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    labelText: localizations.translate("label-new-password"),
                    hintText: localizations.translate("hint-new-password"),
                    icon: Icon(Icons.vpn_key_outlined),
                    iconColor: colorScheme.tertiary.withAlpha(200),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorScheme.tertiary),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorScheme.tertiary),
                    ),
                    floatingLabelStyle: TextStyle(color: colorScheme.tertiary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isNewPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          isNewPasswordVisible = !isNewPasswordVisible;
                        });
                      },
                    ),
                  ),
                  autofocus: true,
                  validator: (value) => value == null || value.isEmpty
                      ? localizations.translate("snackbarRequiredNewPassword")
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: !isConfirmPasswordVisible,
                  focusNode: confirmPasswordFocusNode,
                  style: TextStyle(
                    color: confirmPasswordFocusNode.hasFocus ||
                            confirmPasswordController.text.isNotEmpty
                        ? colorScheme.tertiary
                        : colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    labelText:
                        localizations.translate("label-confirm-password"),
                    hintText: localizations.translate("hint-confirm-password"),
                    icon: Icon(Icons.check_circle_outline),
                    iconColor: colorScheme.tertiary.withAlpha(200),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorScheme.tertiary),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorScheme.tertiary),
                    ),
                    floatingLabelStyle: TextStyle(color: colorScheme.tertiary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  autofocus: true,
                  validator: (value) => value == null || value.isEmpty
                      ? localizations
                          .translate("snackbarRequiredConfirmPassword")
                      : null,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  localizations.translate("text-cancel"),
                  style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.onTertiary),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final currentPassword = currentPasswordController.text.trim();
                  final newPassword = newPasswordController.text.trim();
                  final confirmPassword = confirmPasswordController.text.trim();

                  // Validate inputs
                  if (currentPassword.isEmpty ||
                      newPassword.isEmpty ||
                      confirmPassword.isEmpty) {
                    showSnackBar(
                      context,
                      AppLocalizations.of(context)
                          .translate("snackbarSuccessEditProfile"),
                    );
                    return;
                  }

                  if (newPassword != confirmPassword) {
                    showSnackBar(
                      context,
                      AppLocalizations.of(context)
                          .translate("snackbarFailedEditProfile"),
                    );
                    return;
                  }

                  // Call the changePassword API
                  final apiService = ApiService();
                  final success = await apiService.changePassword({
                    'currentPassword': currentPassword,
                    'newPassword': newPassword,
                  });

                  if (success) {
                    showSnackBar(
                      context,
                      AppLocalizations.of(context)
                          .translate("snackbarSuccessChangePassword"),
                    );
                    Navigator.of(context).pop();
                    refreshUser();
                  } else {
                    showSnackBar(
                      context,
                      AppLocalizations.of(context)
                          .translate("snackbarFailedChangePassword"),
                    );
                  }
                },
                child: Text(
                  localizations.translate("ChangePassword-label-title"),
                  style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.onPrimary),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
