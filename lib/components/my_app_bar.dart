import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? needLogoutButton;
  final Function? logoutButtonOnPressed;
  final bool? needChangeLanguageButton;
  final Function? changeLanguageButtonOnPressed;
  final bool? needStoryWithLocationButton;
  final Function? storyWithLocationButtonOnPressed;
  final Color? storyWithLocationButtonColor;
  final IconData? storyWithLocationButtonIcon;

  const MyAppBar({
    Key? key,
    required this.title,
    this.needLogoutButton,
    this.logoutButtonOnPressed,
    this.needChangeLanguageButton,
    this.changeLanguageButtonOnPressed,
    this.needStoryWithLocationButton,
    this.storyWithLocationButtonOnPressed,
    this.storyWithLocationButtonColor,
    this.storyWithLocationButtonIcon,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        if (needStoryWithLocationButton == true)
          // text button
          TextButton(
            onPressed: () => storyWithLocationButtonOnPressed!(),
            child: Row(
              children: [
                Icon(
                  storyWithLocationButtonIcon,
                  color: storyWithLocationButtonColor,
                ),
                Text(
                  storyWithLocationButtonColor == Colors.red
                      ? 'With Location Only'
                      : 'All',
                  style: TextStyle(
                    color: storyWithLocationButtonColor,
                  ),
                ),
              ],
            ),
          ),
        if (needLogoutButton == true)
          IconButton(
            onPressed: () => logoutButtonOnPressed!(),
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        if (needChangeLanguageButton == true)
          IconButton(
            onPressed: () => changeLanguageButtonOnPressed!(),
            icon: const Icon(
              Icons.language,
              color: Colors.white,
            ),
          ),
      ],
    );
  }
}
