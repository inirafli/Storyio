import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyio/widgets/bottom_navigation_bar.dart';
import 'package:storyio/widgets/home_app_bar_widget.dart';

import '../common/result_state.dart';
import '../preferences/auth_preferences.dart';
import '../provider/story_provider.dart';
import '../widgets/header_home_widget.dart';
import '../widgets/story_card_widget.dart';

class HomeScreen extends StatefulWidget {
  final Function() onLogout;
  final Function() onAdd;
  final ValueChanged<String>? onStoryTap;

  const HomeScreen({
    Key? key,
    required this.onLogout,
    this.onStoryTap,
    required this.onAdd,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  late String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadInitStories();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreStories();
      }
    });
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

  void _loadInitStories() {
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    storyProvider.pageItems = 1;
    AuthPreferences.getUserData().then((user) {
      storyProvider.getAllStories(user.token);
    });
  }

  Future<void> _loadMoreStories() async {
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    if (storyProvider.pageItems != null) {
      AuthPreferences.getUserData().then((user) {
        storyProvider.getAllStories(user.token);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: const HomeAppBar(),
        body: RefreshIndicator(
          onRefresh: () async {
            await _loadUserData();
            _loadInitStories();
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderSection(userName: userName),
                Consumer<StoryProvider>(
                  builder: (context, storyProvider, child) {
                    switch (storyProvider.storyListState) {
                      case ResultState.loading:
                        return Container(
                          constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.65,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      case ResultState.error:
                        return Container(
                          constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.65,
                          ),
                          child: Center(
                            child: Text(
                              storyProvider.storyListErrorMessage ??
                                  'Failed to load Stories',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      case ResultState.done:
                        final stories = storyProvider.storyList;
                        return ListView.separated(
                          key: const PageStorageKey<String>('storylist'),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: stories.length +
                              (storyProvider.pageItems != null ? 1 : 0),
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 24.0),
                          itemBuilder: (context, index) {
                            if (index == stories.length &&
                                storyProvider.pageItems != null) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            height: 72.0,
            width: 72.0,
            child: FittedBox(
              child: FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () {
                  widget.onAdd();
                },
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigation(
          onLanguage: () {
            AppSettings.openAppSettings(type: AppSettingsType.device);
          },
          onLogout: widget.onLogout,
        ),
      ),
    );
  }
}
