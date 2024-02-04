import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/result_state.dart';
import '../preferences/auth_preferences.dart';
import '../provider/story_provider.dart';
import '../widgets/story_detail_widget.dart';

class StoryDetailScreen extends StatefulWidget {
  final String storyId;

  const StoryDetailScreen({Key? key, required this.storyId}) : super(key: key);

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  @override
  void initState() {
    super.initState();
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    AuthPreferences.getUserData().then((user) {
      storyProvider.getStoryDetail(user.token, widget.storyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StoryProvider>(
        builder: (context, storyProvider, child) {
          switch (storyProvider.storyDetailState) {
            case ResultState.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ResultState.done:
              return StoryDetailContent(
                  storyProvider: storyProvider, storyId: widget.storyId);
            case ResultState.error:
              return Center(
                child: Text(storyProvider.storyDetailErrorMessage ??
                    'Failed to load Story Detail'),
              );
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          shape: const CircleBorder(),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
