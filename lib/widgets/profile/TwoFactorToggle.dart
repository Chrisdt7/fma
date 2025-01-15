import 'package:flutter/material.dart';
import 'package:fma/services/ApiService.dart';
import 'package:fma/services/Helpers.dart';
import 'package:fma/templates/AppLocalization.dart';

class TwoFactorToggle extends StatefulWidget {
  final bool is2FAEnabled;
  final ValueChanged<bool> onToggle;

  const TwoFactorToggle({
    Key? key,
    required this.is2FAEnabled,
    required this.onToggle,
  }) : super(key: key);

  @override
  _TwoFactorToggleState createState() => _TwoFactorToggleState();
}

class _TwoFactorToggleState extends State<TwoFactorToggle> {
  bool isLoading = false;

  Future<void> _toggle2FA(bool value) async {
    setState(() {
      isLoading = true;
    });

    try {
      if (value) {
        showEmailVerificationDialog(context, (isEnabled) {
          setState(() {
            isLoading = false;
          });
          widget.onToggle(isEnabled);
        });
      } else {
        // Disable 2FA
        final result = await ApiService().disable2FA();
        if (result != null && result.containsKey('user')) {
          widget.onToggle(result['user']['isTwoFactorEnabled'] ?? false);
          showSnackBar(
              context,
              AppLocalizations.of(context)
                  .translate("snackbarSuccessDisable2FA"),
              isSuccess: true);
        } else {
          showSnackBar(
              context,
              AppLocalizations.of(context)
                  .translate("snackbarFailedDisable2FA"));
        }
      }
    } catch (e) {
      showSnackBar(context, 'Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.security,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(widget.is2FAEnabled
          ? AppLocalizations.of(context).translate("2FA-Disable")
          : AppLocalizations.of(context).translate("2FA-Enable")),
      trailing: isLoading
          ? CircularProgressIndicator()
          : Switch(
              value: widget.is2FAEnabled,
              onChanged: _toggle2FA,
            ),
    );
  }
}
