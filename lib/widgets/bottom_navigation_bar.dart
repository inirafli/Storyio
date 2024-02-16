import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class CustomBottomNavigation extends StatelessWidget {
  final Function() onLanguage;
  final Function() onLogout;

  const CustomBottomNavigation({
    Key? key,
    required this.onLanguage,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 4.0,
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.language,
                size: 24.0,
                color: Theme.of(context).colorScheme.background,
              ),
              onPressed: onLanguage,
            ),
            const SizedBox(width: 72.0),
            IconButton(
              icon: Icon(
                Icons.logout,
                size: 24.0,
                color: Theme.of(context).colorScheme.background,
              ),
              onPressed: () async {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logoutUser();
                onLogout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
