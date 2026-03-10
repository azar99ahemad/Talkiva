import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.maybePop(context),
            )
          : null,
      actions: [
        ...?actions,
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, mode, _) {
            return IconButton(
              icon: Icon(
                mode == ThemeMode.dark ? Icons.wb_sunny : Icons.nightlight_round,
              ),
              onPressed: () async {
                final newMode = mode == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark;
                themeNotifier.value = newMode;
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isDarkMode', newMode == ThemeMode.dark);
              },
            );
          },
        ),
      ],
    );
  }
}
