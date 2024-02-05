import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/model/story.dart';
import '../provider/story_provider.dart';

class StoryDetailContent extends StatelessWidget {
  final StoryProvider storyProvider;
  final String storyId;

  const StoryDetailContent(
      {Key? key, required this.storyProvider, required this.storyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final story = storyProvider.storyList.firstWhere(
      (element) => element.id == storyId,
      orElse: () => Story(
          id: '',
          name: '',
          description: '',
          photoUrl: '',
          createdAt: DateTime.now(),
          lat: 0,
          lon: 0),
    );

    final formattedDate =
        DateFormat('dd MMMM yyyy').format(story.createdAt);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'image-${story.photoUrl}',
              child: CachedNetworkImage(
                cacheKey: 'image-cache-${story.photoUrl}',
                imageUrl: story.photoUrl,
                height: 360,
                width: double.infinity,
                fit: BoxFit.contain,
                placeholder: (context, url) => Image.asset(
                  "assets/loading_image.gif",
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    Text(
                      story.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Posted by ${story.name}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'on $formattedDate',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
