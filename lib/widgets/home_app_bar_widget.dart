import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function() onLogout;

  const HomeAppBar({Key? key, required this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        'Storyio',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.background,
              fontWeight: FontWeight.bold,
            ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.exit_to_app,
            size: 20.0,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
