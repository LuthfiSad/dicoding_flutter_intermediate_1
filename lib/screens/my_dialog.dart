import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intermediate_flutter/provider/auth_provider.dart';
import 'package:intermediate_flutter/provider/story_provider.dart';

class MyDialog extends Page {
  final String title;
  final String message;
  final Function() onOk;

  MyDialog({
    required this.title,
    required this.message,
    required this.onOk,
  }) : super(key: ValueKey(title));

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      // background transparent
      opaque: false,
      settings: this,
      barrierDismissible: true,
      pageBuilder: (context, animation, animation2) {
        return Center(
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<AuthProvider>().setIsFetching(false);
                  context.read<StoryProvider>().setIsFetching(false);
                  onOk();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }
}
