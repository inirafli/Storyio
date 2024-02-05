import 'dart:io';

import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final File? pickedImage;

  const ImageContainer({Key? key, required this.pickedImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        border: pickedImage != null
            ? Border.all(
                color: Colors.transparent,
              )
            : Border.all(
                color: Theme.of(context).colorScheme.primary,
              ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: pickedImage != null
          ? Image.file(
              pickedImage!,
              width: double.infinity,
              fit: BoxFit.contain,
            )
          : Center(
              child: Text(
                'Your Image will be displayed here',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
    );
  }
}
