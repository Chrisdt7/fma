import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fma/services/ApiService.dart';
import 'package:fma/templates/AppLocalization.dart';
import 'package:fma/templates/Themes.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fma/services/Helpers.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final Function(String) changeLanguage;

  const LoginPage({required this.toggleTheme, required this.changeLanguage});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  bool _isPasswordVisible = false;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() => setState(() {}));
    passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (emailController.text.isEmpty) {
      showSnackBar(context,
          AppLocalizations.of(context).translate("snackbarRequiredEmail"));
      return;
    }
    if (passwordController.text.isEmpty) {
      showSnackBar(context,
          AppLocalizations.of(context).translate("snackbarRequiredPassword"));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    bool success = await apiService.login(
      emailController.text,
      passwordController.text,
    );

    Navigator.pop(context);

    if (success) {
      showSnackBar(context,
          AppLocalizations.of(context).translate("snackbarSuccessLogin"),
          isSuccess: true);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showSnackBar(context,
          AppLocalizations.of(context).translate("snackbarFailedLogin"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientTheme = Theme.of(context).extension<AuthGradientTheme>()!;
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);
    String currentLanguage = Localizations.localeOf(context).languageCode;

    return Theme(
        data: Theme.of(context).brightness == Brightness.dark
            ? authDarkTheme
            : authLightTheme,
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: gradientTheme.authBackgroundGradient),
              ),
              Center(
                child: Opacity(
                  opacity: 0.3,
                  child: Icon(
                    FeatherIcons.key,
                    size: 300,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Container(
                    child: Padding(
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
                            AppBar(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              automaticallyImplyLeading: false,
                              flexibleSpace: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        localizations.translate('login-title'),
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: const EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: colorScheme.primary),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize
                                              .min, // Shrinks to fit the content
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                widget.changeLanguage('en');
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  'en',
                                                  style: TextStyle(
                                                    color: currentLanguage ==
                                                            'en'
                                                        ? colorScheme.onSurface
                                                        : colorScheme.surface,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text("/"),
                                            GestureDetector(
                                              onTap: () {
                                                widget.changeLanguage('id');
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  'id',
                                                  style: TextStyle(
                                                    color: currentLanguage ==
                                                            'id'
                                                        ? colorScheme.onSurface
                                                        : colorScheme.surface,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: widget.toggleTheme,
                                      icon: Icon(
                                        Icons.lightbulb_sharp,
                                        size: 30,
                                        color: colorScheme.outlineVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
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
                                labelText:
                                    localizations.translate("label-email"),
                                filled: true,
                                fillColor: colorScheme.surface,
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: colorScheme.tertiary),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: colorScheme.tertiary),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                floatingLabelStyle:
                                    TextStyle(color: colorScheme.tertiary),
                                hintText: localizations.translate("hint-email"),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return localizations
                                      .translate("snackbarRequiredEmail");
                                }
                                return null;
                              },
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
                                labelText:
                                    localizations.translate("label-password"),
                                filled: true,
                                fillColor: colorScheme.surface,
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: colorScheme.tertiary),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: colorScheme.tertiary),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                floatingLabelStyle:
                                    TextStyle(color: colorScheme.tertiary),
                                hintText:
                                    localizations.translate("hint-password"),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons
                                            .visibility_off, // Toggle the icon
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return localizations
                                      .translate("snackbarRequiredPassword");
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              child:
                                  Text(localizations.translate("login-title")),
                              onPressed: _login,
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
                                text: localizations.translate("text-1"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: colorScheme.onSurface
                                          .withOpacity(0.7),
                                    ),
                                children: [
                                  TextSpan(
                                    text: localizations
                                        .translate("register-title"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: colorScheme
                                              .onSurface, // Apply primary color for the link effect
                                          fontWeight: FontWeight.bold,
                                        ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.popAndPushNamed(
                                            context, '/register');
                                      },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
