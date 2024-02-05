import 'package:flutter/material.dart';

import '../common/common.dart';

class HeaderSection extends StatelessWidget {
  final String userName;

  const HeaderSection({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.titleLarge,
              children: [
                TextSpan(text: AppLocalizations.of(context)!.labelGreet),
                TextSpan(
                  text: userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '!'),
              ],
            ),
          ),
          const SizedBox(height: 1.0),
          Text(
            AppLocalizations.of(context)!.labelSubGreet,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
