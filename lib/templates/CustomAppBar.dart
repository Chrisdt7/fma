import 'package:flutter/material.dart';
import 'package:fma/templates/Themes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback toggleTheme;
  final bool showProfileIcon;

  CustomAppBar({
    required this.title,
    required this.toggleTheme,
    this.showProfileIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final appBarGradient =
        Theme.of(context).extension<GradientTheme>()?.appBarGradient;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      title: Text(
        title,
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.primary,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.brightness_6),
          onPressed: toggleTheme,
        ),
        if (showProfileIcon)
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
      ],
      flexibleSpace: appBarGradient != null
          ? Container(
              decoration: BoxDecoration(
                gradient: appBarGradient,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
