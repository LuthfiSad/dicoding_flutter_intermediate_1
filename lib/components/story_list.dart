import 'package:flutter/material.dart';
import 'package:intermediate_flutter/components/funky_bouncy_loader.dart';
import 'package:provider/provider.dart';
// import 'package:intermediate_flutter/components/custom_loading.dart';
import 'package:intermediate_flutter/components/story_card.dart';
import 'package:intermediate_flutter/model/story.dart';
import 'package:intermediate_flutter/provider/story_provider.dart';
import 'dart:math' as math;

class StoryList extends StatefulWidget {
  final Function onTapped;

  const StoryList({
    super.key,
    required this.onTapped,
  });

  @override
  State<StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  late AnimationController loaderController;
  late Animation<double> loaderAnimation;

  @override
  void initState() {
    super.initState();
    final StoryProvider storyProvider = context.read<StoryProvider>();
    scrollController.addListener(
      () {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          if (storyProvider.pageItems != null) {
            storyProvider.getAllStories();
          }
        }
      },
    );

    Future.microtask(() => storyProvider.getAllStories());

    loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    loaderAnimation = Tween(begin: 0.0, end: 1.0).animate(loaderController);
  }

  @override
  void dispose() {
    scrollController.dispose();
    loaderController.dispose();
    loaderAnimation.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, storyProvider, child) {
        if (storyProvider.isFetching == true && storyProvider.pageItems == 1) {
          return Center(
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
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.error,
                      ],
                    ),
                    size: const Size(300, 300),
                  ),
                );
              },
            ),
          );
        } else if (storyProvider.stories.isNotEmpty) {
          return ListView.builder(
            controller: scrollController,
            itemCount: storyProvider.stories.length +
                (storyProvider.pageItems != null ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == storyProvider.stories.length &&
                  storyProvider.pageItems != null) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final Story story = storyProvider.stories[index];
              return Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: StoryCard(
                  id: story.id,
                  name: story.name,
                  description: story.description,
                  photoUrl: story.photoUrl,
                  createdAt: story.createdAt,
                  onTapped: () async {
                    context.read<StoryProvider>().setIsFetching(true);
                    context.read<StoryProvider>().getDetailStories(story.id);
                    widget.onTapped(story.id, null);
                  },
                ),
              );
            },
          );
        } else {
          return const Center(
            child: Text('No Story'),
          );
        }
      },
    );
  }
}
