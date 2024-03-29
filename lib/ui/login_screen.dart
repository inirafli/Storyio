import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyio/common/common.dart';
import 'package:storyio/common/result_state.dart';

import '../provider/auth_provider.dart';
import '../widgets/auth_header_widget.dart';
import '../widgets/custom_action_button_widget.dart';
import '../widgets/custom_text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;

  const LoginScreen({Key? key, required this.onLogin, required this.onRegister})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeaderText(
                    line1: AppLocalizations.of(context)!.loginText,
                    line2: AppLocalizations.of(context)!.loginSubText,
                  ),
                  const SizedBox(height: 32),
                  Text(AppLocalizations.of(context)!.formEmail),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: emailController,
                    hintText: 'Email',
                  ),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.formPassword),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: passwordController,
                    hintText: AppLocalizations.of(context)!.labelPassword,
                    obscureText: true,
                    isPasswordVisible: isPasswordVisible,
                    onSuffixIconPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return CustomActionButton(
                        onPressed: () async {
                          final email = emailController.text;
                          final password = passwordController.text;

                          await authProvider.loginUser(email, password);

                          if (authProvider.loginState == ResultState.error) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.errorMessage ?? 'An error occurred'),
                                ),
                              );
                            }
                          } else if (authProvider.loginState == ResultState.done) {
                            widget.onLogin();
                          }
                        },
                        buttonText: AppLocalizations.of(context)!.loginButtonText,
                        state: authProvider.loginState,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.dontHaveAccount,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  TextButton(
                    onPressed: () {
                      widget.onRegister();
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                        AppLocalizations.of(context)!.registerHere,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
