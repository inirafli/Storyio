import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/result_state.dart';
import '../preferences/auth_preferences.dart';
import '../provider/auth_provider.dart';
import '../provider/story_provider.dart';
import '../widgets/story_card_widget.dart';

class HomeScreen extends StatefulWidget {
  final Function() onLogout;

  const HomeScreen({Key? key, required this.onLogout}) : super(key: key);

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
    final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(0, 48),
          child: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
                'Storyio',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.background,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                    Icons.exit_to_app,
                  size: 20.0,
                  color: Theme.of(context).colorScheme.background,
                ),
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  await authProvider.logoutUser();
                  widget.onLogout();
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
              return ListView.separated(
                key: listKey,
                itemCount: stories.length,
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 16.0),
                itemBuilder: (context, index) {
                  return StoryCard(story: stories[index]);
                },
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add_story');
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Icon(
            Icons.edit,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}