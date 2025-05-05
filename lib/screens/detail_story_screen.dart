import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intermediate_flutter/components/custom_loading.dart';
import 'package:intermediate_flutter/components/google_maps.dart';
import 'package:intermediate_flutter/components/my_app_bar.dart';
import 'package:intermediate_flutter/localization/main.dart';
import 'package:intermediate_flutter/provider/localization_provider.dart';
import 'package:intermediate_flutter/provider/story_provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:math' as math;

class DetailStoryScreen extends StatefulWidget {
  final String storyId;

  const DetailStoryScreen({
    Key? key,
    required this.storyId,
  }) : super(key: key);

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
      duration: const Duration(milliseconds: 1000),
    );
    loaderAnimation = Tween(begin: 1.0, end: 1.4).animate(CurvedAnimation(
      parent: loaderController,
      curve: Curves.easeIn,
    ));
    loaderController.repeat(reverse: true);
  }

  @override
  void dispose() {
    loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StoryProvider, LocalizationProvider>(
      builder: (context, value, localizationProvider, child) => value.isFetching
          ? Center(
              child: AnimatedBuilder(
                animation: loaderController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: loaderController.status == AnimationStatus.forward
                        ? (math.pi * 2) * loaderController.value
                        : -(math.pi * 2) * loaderController.value,
                    child: CustomPaint(
                      foregroundPainter: LoaderAnimation(
                        radiusRatio: loaderAnimation.value,
                      ),
                      size: const Size(300, 300),
                    ),
                  );
                },
              ),
            )
          : Material(
              child: Scaffold(
                appBar: MyAppBar(
                  title: AppLocalizations.of(context)!.detailStory,
                  needChangeLanguageButton: true,
                  changeLanguageButtonOnPressed: () => {
                    localizationProvider.setLocale(
                      localizationProvider.locale == const Locale('en')
                          ? const Locale('id')
                          : const Locale('en'),
                    ),
                  },
                ),
                // scroll view
                body: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        right: 20,
                        left: 20,
                        bottom: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // image
                          SizedBox(
                            height: 250,
                            child: Image.network(
                              value.detailStory.photoUrl,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          // title
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              value.detailStory.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // created at
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            // convert to local timezone (Asia/Jakarta) to readable date
                            child: Text(
                              '${tz.TZDateTime.from(
                                value.detailStory.createdAt,
                                tz.local,
                              ).day.toString()} / ${tz.TZDateTime.from(
                                value.detailStory.createdAt,
                                tz.local,
                              ).month.toString()} / ${tz.TZDateTime.from(
                                value.detailStory.createdAt,
                                tz.local,
                              ).year.toString()}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          // description
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              value.detailStory.description,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          if (value.detailStory.lat != null &&
                              value.detailStory.lon != null)
                            // location
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                AppLocalizations.of(context)!.locationLabel,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (value.detailStory.lat != null &&
                              value.detailStory.lon != null)
                            // google maps
                            const SizedBox(
                              height: 400,
                              child: MyGoogleMaps(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
