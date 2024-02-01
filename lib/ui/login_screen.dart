import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:storyio/common/result_state.dart';

import '../provider/auth_provider.dart';
import '../widgets/auth_header_widget.dart';
import '../widgets/custome_text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
                  const HeaderText(
                    line1: 'Welcome back to Storyio,',
                    line2: 'Login with your Account',
                  ),
                  const SizedBox(height: 32),

                  const Text('Your Email'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: emailController,
                    hintText: 'Email',
                  ),
                  const SizedBox(height: 16),
                  const Text('Your Password'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: passwordController,
                    hintText: 'Password',
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
                      return ElevatedButton(
                        onPressed: authProvider.loginState == ResultState.loading ? null
                            : () async {
                          final email = emailController.text;
                          final password = passwordController.text;
                          final navigator = Navigator.of(context);

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
                            navigator.pushReplacementNamed('/home');
                          }
                        },
                        child: authProvider.loginState == ResultState.loading
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3),
                                  child: SizedBox(
                                    width: 14.0,
                                    height: 14.0,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      strokeWidth: 2.0,
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                          'Login',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Don't have an account?",
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 2),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Register here',
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