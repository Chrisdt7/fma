import 'package:flutter/material.dart';
import 'package:fma/services/ApiService.dart';
import 'package:fma/services/Helpers.dart';
import 'package:fma/templates/AppLocalization.dart';

Future<void> showEditProfileDialog(
    BuildContext context,
    String currentName,
    String currentEmail,
    FocusNode nameFocusNode,
    FocusNode emailFocusNode,
    Function refreshUser) async {
  final TextEditingController nameController =
      TextEditingController(text: currentName);
  final TextEditingController emailController =
      TextEditingController(text: currentEmail);

  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  final colorScheme = theme.colorScheme;
  final localizations = AppLocalizations.of(context);

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        surfaceTintColor: colorScheme.surface,
        title: Text(
          localizations.translate("EditProfile-label-title"),
          textAlign: TextAlign.center,
          style: textTheme.titleLarge
              ?.copyWith(color: colorScheme.tertiary.withAlpha(255)),
        ),
        backgroundColor: theme.dialogBackgroundColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              focusNode: nameFocusNode,
              style: TextStyle(
                color:
                    emailFocusNode.hasFocus || emailController.text.isNotEmpty
                        ? colorScheme.tertiary
                        : colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                labelText: localizations.translate("label-name"),
                hintText: localizations.translate("hint-name"),
                icon: const Icon(Icons.person),
                iconColor: colorScheme.tertiary.withAlpha(200),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorScheme.tertiary),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colorScheme.tertiary),
                ),
                floatingLabelStyle: TextStyle(color: colorScheme.tertiary),
              ),
              autofocus: true,
              validator: (value) => value == null || value.isEmpty
                  ? localizations.translate("snackbarRequiredName")
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              focusNode: emailFocusNode,
              style: TextStyle(
                color:
                    emailFocusNode.hasFocus || emailController.text.isNotEmpty
                        ? colorScheme.tertiary
                        : colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                labelText: localizations.translate("label-email"),
                hintText: localizations.translate("hint-email"),
                icon: const Icon(Icons.email),
                iconColor: colorScheme.tertiary.withAlpha(200),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorScheme.tertiary),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colorScheme.tertiary),
                ),
                floatingLabelStyle: TextStyle(color: colorScheme.tertiary),
              ),
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
              validator: (value) => value == null || value.isEmpty
                  ? localizations.translate("snackbarRequiredEmail")
                  : null,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.translate("text-cancel"),
                style: textTheme.titleMedium
                    ?.copyWith(color: colorScheme.onTertiary)),
          ),
          TextButton(
            onPressed: () async {
              final updatedName = nameController.text.trim();
              final updatedEmail = emailController.text.trim();

              // Validate inputs
              if (updatedName.isEmpty || updatedEmail.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All fields are required')),
                );
                return;
              }

              // Call the updateUser API
              final apiService = ApiService();
              final success = await apiService.updateUser({
                'name': updatedName,
                'email': updatedEmail,
              }, null);

              if (success) {
                showSnackBar(
                  context,
                  AppLocalizations.of(context)
                      .translate("snackbarMatchPassword"),
                );
                Navigator.of(context).pop();
                refreshUser();
              } else {
                showSnackBar(
                  context,
                  AppLocalizations.of(context)
                      .translate("snackbarMatchPassword"),
                );
              }
            },
            child: Text(
              localizations.translate("text-save"),
              style:
                  textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary),
            ),
          ),
        ],
      );
    },
  );
}
