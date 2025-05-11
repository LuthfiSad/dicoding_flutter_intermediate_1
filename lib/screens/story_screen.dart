import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intermediate_flutter/components/my_app_bar.dart';
import 'package:intermediate_flutter/components/story_list.dart';
import 'package:intermediate_flutter/flavor_config.dart';
import 'package:intermediate_flutter/provider/story_provider.dart';

class StoryScreen extends StatefulWidget {
  final Function logoutButtonOnPressed;
  final Function onTapped;
  final Function onAddStoryButtonPressed;
  final Function showDialogPermissionVersion;

  const StoryScreen({
    super.key,
    required this.logoutButtonOnPressed,
    required this.onTapped,
    required this.onAddStoryButtonPressed,
    required this.showDialogPermissionVersion,
  });

  static const String routeName = '/story';

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, storyProvider, child) {
        return Scaffold(
          appBar: MyAppBar(
            title: FlavorConfig.instance.values.titleApp,
            needLogoutButton: true,
            logoutButtonOnPressed: () => widget.logoutButtonOnPressed(),
            needStoryWithLocationButton: true,
            storyWithLocationButtonOnPressed: widget.showDialogPermissionVersion,
            storyWithLocationButtonColor:
                storyProvider.isStoryNeedLocation ? Colors.red : Colors.white,
            storyWithLocationButtonIcon: storyProvider.isStoryNeedLocation
                ? Icons.location_on
                : Icons.location_off,
          ),
          body: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.015,
                    left: MediaQuery.of(context).size.width * 0.040,
                    right: MediaQuery.of(context).size.width * 0.040,
                    bottom: MediaQuery.of(context).size.height * 0.015,
                  ),
                  child: StoryList(
                    onTapped: widget.onTapped,
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              widget.onAddStoryButtonPressed();
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ), // Icon
          ),
        );
      },
    );
  }
}
