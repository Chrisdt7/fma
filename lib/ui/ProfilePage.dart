import 'package:flutter/material.dart';
import 'package:fma/services/ApiService.dart';
import 'package:fma/services/AuthService.dart';
import 'package:fma/services/Helpers.dart';
import 'package:fma/templates/AppLocalization.dart';
import 'package:fma/templates/CustomAppBar.dart';
import 'package:fma/templates/Themes.dart';
import 'package:fma/widgets/profile/ChangePasswordDialog.dart';
import 'package:fma/widgets/profile/EditProfileDialog.dart';
import 'package:fma/widgets/profile/TwoFactorToggle.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final Function(String) changeLanguage;

  const ProfilePage(
      {Key? key, required this.toggleTheme, required this.changeLanguage})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool isLoading = true;
  bool is2FAEnabled = false;
  String currentLanguage = 'en';

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    nameFocusNode.addListener(() => setState(() {}));
    emailFocusNode.addListener(() => setState(() {}));
    passwordFocusNode.addListener(() => setState(() {}));
    newPasswordFocusNode.addListener(() => setState(() {}));
    confirmPasswordFocusNode.addListener(() => setState(() {}));
    _fetchUser();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchUser() async {
    try {
      final data = await ApiService().getUser();
      setState(() {
        user = data;
        is2FAEnabled = user?['isTwoFactorEnabled'] ?? false;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
          context, AppLocalizations.of(context).translate("snackbarFailedGet"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientTheme = Theme.of(context).extension<GradientTheme>()!;
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.translate("profile-title"),
        toggleTheme: widget.toggleTheme,
        showProfileIcon: false,
      ),
      body: Stack(
        children: [
          Container(
            decoration:
                BoxDecoration(gradient: gradientTheme.backgroundGradient),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLanguageButton('en'),
                          const SizedBox(width: 16),
                          _buildLanguageButton('id'),
                        ],
                      ),
                      Center(
                        child: FutureBuilder(
                          future: preloadAssetImage(context, user?['image']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircleAvatar(
                                radius: 50,
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return CircleAvatar(
                                radius: 50,
                                backgroundColor: colorScheme.error,
                                child: Icon(Icons.error,
                                    color: colorScheme.onError),
                              );
                            } else {
                              return CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(
                                    'assets/image/profile/${user!['image']}'),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: colorScheme.primary,
                                          width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  width: 80,
                                  height: 80,
                                  child: CircleAvatar(
                                    backgroundColor:
                                        colorScheme.surface.withAlpha(255),
                                    radius: 15,
                                    child: IconButton(
                                        padding: EdgeInsets.all(0),
                                        alignment: Alignment.center,
                                        color: colorScheme.onPrimary,
                                        iconSize: 20,
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.camera_alt,
                                        )),
                                  ),
                                  alignment: Alignment.bottomRight,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(user?['name'] ?? 'N/A',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.9),
                                )),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(user?['email'] ?? 'N/A',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                )),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        localizations.translate("AccountDetails-label-title"),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.9),
                            ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        iconColor: colorScheme.onSurface.withOpacity(0.8),
                        textColor: colorScheme.onSurface.withOpacity(0.8),
                        leading: const Icon(Icons.person),
                        title: const Text('Name'),
                        subtitle: Text(user?['name'] ?? 'N/A'),
                      ),
                      ListTile(
                        iconColor: colorScheme.onSurface.withOpacity(0.8),
                        textColor: colorScheme.onSurface.withOpacity(0.8),
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: Text(user?['email'] ?? 'N/A'),
                      ),
                      // Add additional fields if needed
                      const SizedBox(height: 32),
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () => showEditProfileDialog(
                                  context,
                                  user?['name'] ?? '',
                                  user?['email'] ?? '',
                                  nameFocusNode,
                                  emailFocusNode,
                                  _fetchUser,
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.edit),
                                    const SizedBox(width: 8),
                                    Text(localizations
                                        .translate("EditProfile-label-title")),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () => showChangePasswordDialog(
                                  context,
                                  passwordFocusNode,
                                  newPasswordFocusNode,
                                  confirmPasswordFocusNode,
                                  _fetchUser,
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.lock),
                                    const SizedBox(width: 8),
                                    Text(localizations.translate(
                                        "ChangePassword-label-title")),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await AuthService().logout(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.logout),
                                    const SizedBox(width: 8),
                                    Text(localizations
                                        .translate("Logout-label-title")),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TwoFactorToggle(
                        is2FAEnabled: is2FAEnabled,
                        onToggle: (value) {
                          setState(() {
                            is2FAEnabled = value;
                            user?['isTwoFactorEnabled'] = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String languageCode) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          currentLanguage = languageCode;
          widget.changeLanguage(languageCode);
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      ),
      child: Text(languageCode.toUpperCase()), // Display the language code
    );
  }
}
