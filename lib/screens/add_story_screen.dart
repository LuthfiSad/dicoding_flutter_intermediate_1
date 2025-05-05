import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intermediate_flutter/components/google_maps.dart';
import 'package:intermediate_flutter/components/my_app_bar.dart';
import 'package:intermediate_flutter/localization/main.dart';
import 'package:intermediate_flutter/provider/localization_provider.dart';
import 'package:intermediate_flutter/provider/map_provider.dart';
import 'package:intermediate_flutter/provider/story_provider.dart';

class AddStoryScreen extends StatefulWidget {
  final Function addStoryButtonOnPressed;

  const AddStoryScreen({
    Key? key,
    required this.addStoryButtonOnPressed,
  }) : super(key: key);

  static const String routeName = '/add_story';

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<StoryProvider, LocalizationProvider, MapProvider>(
      builder:
          (context, storyProvider, localizationProvider, mapProvider, child) {
        return OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) {
              return Scaffold(
                appBar: MyAppBar(
                  title: AppLocalizations.of(context)!.addStory,
                  needChangeLanguageButton: true,
                  changeLanguageButtonOnPressed: () => {
                    localizationProvider.setLocale(
                      localizationProvider.locale == const Locale('en')
                          ? const Locale('id')
                          : const Locale('en'),
                    ),
                  },
                  needStoryWithLocationButton: true,
                  storyWithLocationButtonOnPressed: () {
                    storyProvider.setStoryNeedLocation(
                        !storyProvider.isStoryNeedLocation);
                  },
                  storyWithLocationButtonColor:
                      storyProvider.isStoryNeedLocation
                          ? Colors.red
                          : Colors.white,
                ),
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.15,
                      right: MediaQuery.of(context).size.width * 0.15,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1,
                          bottom: MediaQuery.of(context).size.height * 0.1,
                        ),
                        child: Column(
                          // the children should be aligned to the center
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // image placeholder preview
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Center(
                                child: storyProvider.imagePath == null
                                    ? const Icon(Icons.image, size: 100.0)
                                    : Image.file(
                                        File(
                                          context
                                              .read<StoryProvider>()
                                              .imagePath!
                                              .toString(),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            // row for gallery and camera
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // gallery button
                                ElevatedButton(
                                  onPressed: () {
                                    storyProvider.onGalleryView();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.gallery,
                                  ),
                                ),
                                // camera button
                                ElevatedButton(
                                  onPressed: () {
                                    storyProvider.onCameraView();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.camera,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            if (storyProvider.isStoryNeedLocation)
                              // location
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  AppLocalizations.of(context)!.locationLabel,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (storyProvider.isStoryNeedLocation)
                              // google maps
                              const SizedBox(
                                height: 400,
                                child: MyGoogleMaps(),
                              ),
                            if (storyProvider.isStoryNeedLocation)
                              const SizedBox(height: 20.0),
                            // the form
                            Form(
                              child: Column(
                                children: [
                                  const SizedBox(height: 20.0),
                                  // the content field
                                  TextFormField(
                                    controller: _contentController,
                                    decoration: InputDecoration(
                                      alignLabelWithHint: true,
                                      labelText:
                                          AppLocalizations.of(context)!.content,
                                      border: const OutlineInputBorder(),
                                    ),
                                    maxLines: 5,
                                  ),
                                  const SizedBox(height: 20.0),
                                  // the submit button
                                  storyProvider.isFetching
                                      ? const CircularProgressIndicator()
                                      : SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              var response = await storyProvider
                                                  .addNewStory(
                                                _contentController.text,
                                                AppLocalizations.of(context)!
                                                    .imageNotFound,
                                                mapProvider
                                                    .userLocation!.latitude,
                                                mapProvider
                                                    .userLocation!.longitude,
                                              );

                                              if (response.error == true) {
                                                widget.addStoryButtonOnPressed(
                                                  response.error,
                                                  response.message,
                                                );
                                                return;
                                              } else if (response.error ==
                                                  false) {
                                                widget.addStoryButtonOnPressed(
                                                  response.error,
                                                  response.message,
                                                );
                                              }

                                              await storyProvider
                                                  .getAllStories();
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .upload,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                appBar: MyAppBar(
                  title: AppLocalizations.of(context)!.addStory,
                  needChangeLanguageButton: true,
                  changeLanguageButtonOnPressed: () => {
                    localizationProvider.setLocale(
                      localizationProvider.locale == const Locale('en')
                          ? const Locale('id')
                          : const Locale('en'),
                    ),
                  },
                  needStoryWithLocationButton: true,
                  storyWithLocationButtonOnPressed: () {
                    storyProvider.setStoryNeedLocation(
                        !storyProvider.isStoryNeedLocation);
                  },
                  storyWithLocationButtonColor:
                      storyProvider.isStoryNeedLocation
                          ? Colors.red
                          : Colors.white,
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.03,
                      left: MediaQuery.of(context).size.width * 0.15,
                      right: MediaQuery.of(context).size.width * 0.15,
                      bottom: MediaQuery.of(context).size.height * 0.03,
                    ),
                    child: Column(
                      children: [
                        // image placeholder preview
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Center(
                            child: storyProvider.imagePath == null
                                ? const Icon(Icons.image, size: 100.0)
                                : Image.file(
                                    File(
                                      context
                                          .read<StoryProvider>()
                                          .imagePath!
                                          .toString(),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        // row for gallery and camera
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // gallery button
                            ElevatedButton(
                              onPressed: () {
                                storyProvider.onGalleryView();
                              },
                              child: Text(
                                AppLocalizations.of(context)!.gallery,
                              ),
                            ),
                            // camera button
                            ElevatedButton(
                              onPressed: () {
                                storyProvider.onCameraView();
                              },
                              child: Text(
                                AppLocalizations.of(context)!.camera,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        if (storyProvider.isStoryNeedLocation)
                          // location
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              AppLocalizations.of(context)!.locationLabel,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (storyProvider.isStoryNeedLocation)
                          // google maps
                          const SizedBox(
                            height: 400,
                            child: MyGoogleMaps(),
                          ),
                        if (storyProvider.isStoryNeedLocation)
                          const SizedBox(height: 20.0),
                        // the form
                        Form(
                          child: Column(
                            children: [
                              const SizedBox(height: 20.0),
                              // the content field
                              TextFormField(
                                controller: _contentController,
                                decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  labelText:
                                      AppLocalizations.of(context)!.content,
                                  border: const OutlineInputBorder(),
                                ),
                                maxLines: 5,
                              ),
                              const SizedBox(height: 20.0),
                              // the submit button
                              storyProvider.isFetching
                                  ? const CircularProgressIndicator()
                                  : SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          var response =
                                              await storyProvider.addNewStory(
                                            _contentController.text,
                                            AppLocalizations.of(context)!
                                                .imageNotFound,
                                            mapProvider.userLocation!.latitude,
                                            mapProvider.userLocation!.longitude,
                                          );

                                          if (response.error == true) {
                                            widget.addStoryButtonOnPressed(
                                              response.error,
                                              response.message,
                                            );
                                            return;
                                          } else if (response.error == false) {
                                            widget.addStoryButtonOnPressed(
                                              response.error,
                                              response.message,
                                            );
                                          }
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.upload,
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
