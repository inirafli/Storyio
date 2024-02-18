import 'package:flutter/material.dart';
import '../common/result_state.dart';

class CustomActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final ResultState state;

  const CustomActionButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: state == ResultState.loading ? null : onPressed,
      child: state == ResultState.loading
          ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: SizedBox(
              width: 14.0,
              height: 14.0,
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.background,
                strokeWidth: 2.0,
              ),
            ),
          )
          : Text(
              buttonText,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.background,
                  ),
            ),
    );
  }
}
