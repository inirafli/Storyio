import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/model/user.dart';
import '../preferences/auth_preferences.dart';
import '../provider/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logoutUser();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Storyio App!'),
            SizedBox(height: 16),
            FutureBuilder<User>(
              future: AuthPreferences.getUserData(), // Get user data asynchronously
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator while fetching data
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Handle errors
                  return Text('Error: ${snapshot.error}');
                } else {
                  final user = snapshot.data;
                  // Display user information
                  return Text('User: ${user?.name ?? 'Not logged in'}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}