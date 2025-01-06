import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fma/services/ApiService.dart';
import 'package:fma/templates/Themes.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fma/services/Helpers.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const RegisterPage({required this.toggleTheme});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  File? _selectedImage;
  bool _isPasswordVisible = false;

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    nameFocusNode.addListener(() => setState(() {}));
    emailFocusNode.addListener(() => setState(() {}));
    passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _pickImageHandler() async {
    final image = await pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _register() async {
    if (nameController.text.isEmpty) {
      showSnackBar(context, 'Email is required');
      return;
    }
    if (emailController.text.isEmpty) {
      showSnackBar(context, 'Email is required');
      return;
    }
    if (passwordController.text.isEmpty) {
      showSnackBar(context, 'Password is required');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    final bool success = await apiService.register(
      nameController.text,
      emailController.text,
      passwordController.text,
      _selectedImage!,
    );

    Navigator.pop(context); // Dismiss loading indicator

    if (success) {
      showSnackBar(context, 'Registration successful!', isSuccess: true);
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      showSnackBar(context, 'Registration failed. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientTheme = Theme.of(context).extension<AuthGradientTheme>()!;
    final colorScheme = Theme.of(context).colorScheme;

    return Theme(
      data: Theme.of(context).brightness == Brightness.dark
          ? authDarkTheme
          : authLightTheme,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration:
                  BoxDecoration(gradient: gradientTheme.authBackgroundGradient),
            ),
            Center(
              child: Opacity(
                opacity: 0.3,
                child: Icon(
                  FeatherIcons.userPlus,
                  size: 300,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: widget.toggleTheme,
                    icon: Icon(
                      Icons.lightbulb_sharp,
                      size: 50,
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.onSurface.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                            color: colorScheme.surface.withOpacity(0.4)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: _pickImageHandler,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: colorScheme.surface,
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : null,
                              child: _selectedImage == null
                                  ? Icon(
                                      Icons.add_a_photo,
                                      size: 30,
                                      color: colorScheme.primary,
                                    )
                                  : null,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: nameController,
                            focusNode: nameFocusNode,
                            style: TextStyle(
                              color: nameFocusNode.hasFocus ||
                                      nameController.text.isNotEmpty
                                  ? colorScheme.tertiary
                                  : colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Name',
                              filled: true,
                              fillColor: colorScheme.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: colorScheme.tertiary),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              floatingLabelStyle:
                                  TextStyle(color: colorScheme.tertiary),
                              hintText: 'Your Name',
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: emailController,
                            focusNode: emailFocusNode,
                            style: TextStyle(
                              color: emailFocusNode.hasFocus ||
                                      emailController.text.isNotEmpty
                                  ? colorScheme.tertiary
                                  : colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              filled: true,
                              fillColor: colorScheme.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: colorScheme.tertiary),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              floatingLabelStyle:
                                  TextStyle(color: colorScheme.tertiary),
                              hintText: 'examples@gmail.com',
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            style: TextStyle(
                              color: passwordFocusNode.hasFocus ||
                                      passwordController.text.isNotEmpty
                                  ? colorScheme.tertiary
                                  : colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              filled: true,
                              fillColor: colorScheme.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: colorScheme.tertiary),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              floatingLabelStyle:
                                  TextStyle(color: colorScheme.tertiary),
                              hintText: '••••••••',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off, // Toggle the icon
                                  color: colorScheme.onSurface,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible =
                                        !_isPasswordVisible; // Toggle visibility
                                  });
                                },
                              ),
                            ),
                            obscureText: !_isPasswordVisible,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            child: Text('Sign Up'),
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: colorScheme.primary,
                              backgroundColor: colorScheme.onPrimary,
                              shadowColor: colorScheme.primary,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.7),
                                  ),
                              children: [
                                TextSpan(
                                  text: 'Login',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
