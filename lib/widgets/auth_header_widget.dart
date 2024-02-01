import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String line1;
  final String line2;

  const HeaderText({Key? key, required this.line1, required this.line2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          line1,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 6.0),
        Text(
          line2,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
