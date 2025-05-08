import 'package:flutter/material.dart';
import 'package:intermediate_flutter/components/funky_bouncy_loader.dart';
import 'package:provider/provider.dart';
import 'package:intermediate_flutter/components/my_app_bar.dart';
import 'package:intermediate_flutter/localization/main.dart';
import 'package:intermediate_flutter/provider/localization_provider.dart';
import 'package:intermediate_flutter/provider/story_provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:math' as math;

class DetailStoryScreen extends StatefulWidget {
  final String storyId;

  const DetailStoryScreen({
    super.key,
    required this.storyId,
  });

  @override
  State<DetailStoryScreen> createState() => _DetailStoryScreenState();
}

class _DetailStoryScreenState extends State<DetailStoryScreen>
    with TickerProviderStateMixin {
  late AnimationController loaderController;
  late Animation<double> loaderAnimation;

  @override
  void initState() {
    super.initState();
    loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    loaderAnimation = Tween(begin: 0.0, end: 1.0).animate(loaderController);
  }

  @override
  void dispose() {
    loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final storyProvider = context.watch<StoryProvider>();
    final localizationProvider = context.watch<LocalizationProvider>();

    return storyProvider.isFetching
        ? Center(
            child: AnimatedBuilder(
              animation: loaderController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: loaderController.status == AnimationStatus.forward
                      ? (math.pi * 2) * loaderController.value
                      : -(math.pi * 2) * loaderController.value,
                  child: CustomPaint(
                    painter: FunkyBouncyLoader(
                      progress: loaderAnimation.value,
                      dotColors: [
                        Colors.cyanAccent,
                        Colors.blueAccent,
                        Colors.yellowAccent,
                      ],
                    ),
                    size: const Size(300, 300),
                  ),
                );
              },
            ),
          )
        : Scaffold(
            appBar: MyAppBar(
              title: AppLocalizations.of(context)!.detailStory,
              needChangeLanguageButton: true,
              changeLanguageButtonOnPressed: () {
                localizationProvider.setLocale(
                  localizationProvider.locale == const Locale('en')
                      ? const Locale('id')
                      : const Locale('en'),
                );
              },
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Story Image with Hero Animation
                  Hero(
                    tag: 'story-image-${storyProvider.detailStory.id}',
                    child: Container(
                      height: 300,
                      margin: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        child: Image.network(
                          storyProvider.detailStory.photoUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      size: 60,
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      // AppLocalizations.of(context)!
                                      //     .failedToLoadImage,
                                      "Failed to load image",
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Story Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Author and Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Author
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 20,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  storyProvider.detailStory.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            // Date
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 16,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  tz.TZDateTime
                                      .from(
                                        storyProvider.detailStory.createdAt,
                                        tz.local,
                                      )
                                      .toString()
                                      .substring(0, 10),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Story Description
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            storyProvider.detailStory.description,
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.justify,
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