import 'package:flutter/material.dart';
import 'package:intermediate_flutter/localization/main.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? needLogoutButton;
  final Function? logoutButtonOnPressed;
  final bool? needChangeLanguageButton;
  final Function? changeLanguageButtonOnPressed;

  const MyAppBar({
    super.key,
    required this.title,
    this.needLogoutButton,
    this.logoutButtonOnPressed,
    this.needChangeLanguageButton,
    this.changeLanguageButtonOnPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60); // Slightly taller

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
        elevation: 0, // Remove default shadow
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Ganti ke warna yang kamu mau
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        actions: [
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