import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../common/common.dart';
import '../data/model/story.dart';
import '../provider/story_provider.dart';
import 'location_info_widget.dart';

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

    final formattedDate = DateFormat('dd MMMM yyyy').format(story.createdAt);

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
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    '${AppLocalizations.of(context)!.detailLabel}${story.name}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${AppLocalizations.of(context)!.detailOn} $formattedDate',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    AppLocalizations.of(context)!.detailLocationOn,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12.0),
                  if (story.lat != 0 && story.lon != 0)
                    Stack(
                      children: [
                        SizedBox(
                          height: 320,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(story.lat, story.lon),
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId:
                                    const MarkerId('story_location_marker'),
                                position: LatLng(story.lat, story.lon),
                              ),
                            },
                            padding: const EdgeInsets.only(
                              bottom: 104.0,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: LocationInfoWidget(
                            selectedLocation: LatLng(story.lat, story.lon),
                            titleFontSize: 16.0,
                            subtitleFontSize: 12.0,
                          ),
                        ),
                      ],
                    )
                  else
                    Container(
                      height: 130,
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context)!.detailNoLocation,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  const SizedBox(height: 32.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
