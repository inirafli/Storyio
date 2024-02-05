import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:storyio/data/model/story.dart';

class StoryCard extends StatelessWidget {
  final Story story;
  final Function() onStoryTap;

  const StoryCard({Key? key, required this.story, required this.onStoryTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStoryTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'image-${story.photoUrl}',
                  child: CachedNetworkImage(
                    cacheKey: 'image-cache-${story.photoUrl}',
                    imageUrl: story.photoUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                      "assets/loading_image.gif",
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    cacheManager: CacheManager(Config(
                      'image-cache-${story.photoUrl}',
                      stalePeriod: const Duration(days: 1),
                    )),
                  ),
                ),
                Positioned(
                  bottom: 4.0,
                  right: 4.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 10.0),
                    color: Colors.black.withOpacity(0.65),
                    child: Text(
                      DateFormat('dd MMMM yyyy').format(story.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.background,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.account_circle_rounded,
                    color: Theme.of(context).colorScheme.surface,
                    size: 32.0,
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium?.copyWith(
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          story.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
