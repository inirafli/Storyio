import 'package:flutter/material.dart';

class FloatBackButton extends StatelessWidget {
  final Function() onBack;

  const FloatBackButton({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: FloatingActionButton(
        onPressed: onBack,
        mini: true,
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
