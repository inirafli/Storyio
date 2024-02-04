import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/result_state.dart';
import '../preferences/auth_preferences.dart';
import '../provider/auth_provider.dart';
import '../provider/story_provider.dart';
import '../widgets/story_card_widget.dart';

class HomeScreen extends StatefulWidget {
  final Function() onLogout;
  final ValueChanged<String>? onStoryTap;

  const HomeScreen({Key? key, required this.onLogout, this.onStoryTap})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  late String userName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadStories();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> _loadUserData() async {
    final user = await AuthPreferences.getUserData();
    setState(() {
      userName = user.name;
    });
  }

  void _loadStories() {
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
                  final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
                  await authProvider.logoutUser();
                  widget.onLogout();
                },
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _loadUserData();
            _loadStories();
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.titleLarge,
                          children: [
                            const TextSpan(text: 'Hello, '),
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
                        'Discover new stories and share your own',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Consumer<StoryProvider>(
                  builder: (context, storyProvider, child) {
                    if (storyProvider.storyListState == ResultState.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (storyProvider.storyListState == ResultState.error) {
                      return Center(
                        child: Text(storyProvider.storyListErrorMessage ??
                            'Failed to load Stories'),
                      );
                    } else {
                      final stories = storyProvider.storyList;
                      return ListView.separated(
                        key: const PageStorageKey<String>('storylist'),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: stories.length,
                        separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 24.0),
                        itemBuilder: (context, index) {
                          return StoryCard(
                            story: stories[index],
                            onStoryTap: () {
                              widget.onStoryTap?.call(stories[index].id);
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
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