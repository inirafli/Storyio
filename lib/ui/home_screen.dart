import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/result_state.dart';
import '../preferences/auth_preferences.dart';
import '../provider/auth_provider.dart';
import '../provider/story_provider.dart';
import '../widgets/story_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    AuthPreferences.getUserData().then((user) {
      storyProvider.getAllStories(user.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(0, 46),
          child: AppBar(
            title: Text(
                'Storyio',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                    Icons.exit_to_app,
                  size: 20.0,
                ),
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  await authProvider.logoutUser();
                  navigator.pushReplacementNamed('/login');
                },
              ),
            ],
          ),
        ),
        body: Consumer<StoryProvider>(
          builder: (context, storyProvider, child) {
            if (storyProvider.storyListState == ResultState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (storyProvider.storyListState == ResultState.error) {
              return Center(
                child: Text(storyProvider.storyListErrorMessage ?? 'Failed to load Stories'),
              );
            } else {
              final stories = storyProvider.storyList;
              return ListView.builder(
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  return StoryCard(story: stories[index]);
                },
              );
            }
          },
        ),
      ),
    );
  }
}