import 'package:flutter/material.dart';
import 'package:fma/services/ApiService.dart';

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
              'Change Password',
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
                    labelText: 'Current Password',
                    hintText: 'Enter your old password',
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
                      ? 'Please enter your name'
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
                    labelText: 'New Password',
                    hintText: 'Enter your new password',
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
                      ? 'Please enter your name'
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
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your new password',
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
                      ? 'Please enter your name'
                      : null,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All fields are required')),
                    );
                    return;
                  }

                  if (newPassword != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Password changed successfully')),
                    );
                    Navigator.of(context).pop();
                    refreshUser();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Failed to change password')),
                    );
                  }
                },
                child: Text(
                  'Change Password',
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
