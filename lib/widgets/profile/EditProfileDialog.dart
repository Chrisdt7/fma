import 'package:flutter/material.dart';
import 'package:fma/services/ApiService.dart';

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

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        surfaceTintColor: colorScheme.surface,
        title: Text(
          'Edit Profile',
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
                labelText: 'Name',
                hintText: 'Enter your name',
                icon: Icon(Icons.person),
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
                  ? 'Please enter your name'
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
                labelText: 'Email',
                hintText: 'Enter your email',
                icon: Icon(Icons.email),
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
                  ? 'Please enter your email'
                  : null,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel',
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
                Navigator.of(context).pop();
                refreshUser();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to update profile')),
                );
              }
            },
            child: Text(
              'Save',
              style:
                  textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary),
            ),
          ),
        ],
      );
    },
  );
}
