import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final Function() onCameraView;
  final Function() onGalleryView;

  const ActionButtons({
    Key? key,
    required this.onCameraView,
    required this.onGalleryView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onCameraView,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.secondary,
            ),
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              Icons.camera_alt,
              size: 28.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: onGalleryView,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              Icons.image,
              size: 28.0,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
