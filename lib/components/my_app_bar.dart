import 'package:flutter/material.dart';
import 'package:intermediate_flutter/localization/main.dart';

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
    super.key,
    required this.title,
    this.needLogoutButton,
    this.logoutButtonOnPressed,
    this.needChangeLanguageButton,
    this.changeLanguageButtonOnPressed,
    this.needStoryWithLocationButton,
    this.storyWithLocationButtonOnPressed,
    this.storyWithLocationButtonColor,
    this.storyWithLocationButtonIcon,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        actions: [
          if (needStoryWithLocationButton == true)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: storyWithLocationButtonColor?.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: storyWithLocationButtonColor ?? Colors.transparent,
                  width: 1,
                ),
              ),
              child: TextButton(
                onPressed: () => storyWithLocationButtonOnPressed!(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: Row(
                  children: [
                    Icon(
                      storyWithLocationButtonIcon,
                      color: storyWithLocationButtonColor,
                      size: storyWithLocationButtonIcon == null ? 0 : 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      storyWithLocationButtonColor == Colors.red
                          ? AppLocalizations.of(context)!.onlyStory
                          : AppLocalizations.of(context)!.withLocation,
                      style: TextStyle(
                        color: storyWithLocationButtonColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          if (needChangeLanguageButton == true) ...[
            const SizedBox(width: 8),
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              child: IconButton(
                onPressed: () => changeLanguageButtonOnPressed!(),
                icon: const Icon(
                  Icons.language,
                  color: Colors.white,
                ),
                tooltip: AppLocalizations.of(context)!.changeLanguage,
              ),
            ),
          ],
            
          
          if (needLogoutButton == true) ...[
            const SizedBox(width: 8),
            Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              child: IconButton(
                onPressed: () => logoutButtonOnPressed!(),
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                tooltip: AppLocalizations.of(context)!.confirmLogout,
              ),
            ),
          ],
        ],
      ),
    );
  }
}