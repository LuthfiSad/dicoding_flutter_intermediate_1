import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intermediate_flutter/components/my_app_bar.dart';
import 'package:intermediate_flutter/localization/main.dart';
import 'package:intermediate_flutter/provider/localization_provider.dart';
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
    final theme = Theme.of(context);
    final storyProvider = context.watch<StoryProvider>();

    return Scaffold(
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.addStory,
        needChangeLanguageButton: true,
        changeLanguageButtonOnPressed: () {
          context.read<LocalizationProvider>().setLocale(
                context.read<LocalizationProvider>().locale == const Locale('en')
                    ? const Locale('id')
                    : const Locale('en'),
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image Preview Section
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: storyProvider.imagePath == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_search,
                          size: 60,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.noImageSelected,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(storyProvider.imagePath!),
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(height: 24),

            // Media Selection Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.photo_library, 
                        color: theme.colorScheme.primary),
                    label: Text(AppLocalizations.of(context)!.gallery),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: theme.colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => storyProvider.onGalleryView(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    label: Text(AppLocalizations.of(context)!.camera),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => storyProvider.onCameraView(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Story Content Section
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.content,
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
              ),
              maxLines: 5,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: storyProvider.isFetching
                    ? null
                    : () async {
                        final response = await storyProvider.addNewStory(
                          _contentController.text,
                          AppLocalizations.of(context)!.imageNotFound
                        );

                        widget.addStoryButtonOnPressed(
                          response.error,
                          response.message,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: storyProvider.isFetching
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context)!.upload,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}