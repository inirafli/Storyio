import 'package:flutter/material.dart';

class FloatBackButton extends StatelessWidget {
  const FloatBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        mini: true,
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
