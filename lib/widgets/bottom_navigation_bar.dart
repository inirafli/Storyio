import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  final Function() onLanguage;
  final Function() onMaps;

  const CustomBottomNavigation({
    Key? key,
    required this.onLanguage,
    required this.onMaps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66.0,
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
                size: 26.0,
                color: Theme.of(context).colorScheme.background,
              ),
              onPressed: onLanguage,
            ),
            const SizedBox(width: 72.0),
            IconButton(
              icon: Icon(
                Icons.location_on,
                size: 26.0,
                color: Theme.of(context).colorScheme.background,
              ),
              onPressed: onMaps,
            ),
          ],
        ),
      ),
    );
  }
}
