import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intermediate_flutter/provider/auth_provider.dart';
import 'package:intermediate_flutter/provider/story_provider.dart';

class MyDialog extends Page {
  final String title;
  final String message;
  final Function() onOk;
  final Function()? onCancel; // Optional callback for cancel/no action
  final String? okText; // Customizable text for positive button
  final String? cancelText; // Customizable text for negative button
  final bool showTwoActions; // Flag to show one or two actions

  MyDialog({
    required this.title,
    required this.message,
    required this.onOk,
    this.onCancel,
    this.okText = 'OK',
    this.cancelText = 'Cancel',
    this.showTwoActions = false,
  }) : super(key: ValueKey(title));

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      opaque: false,
      settings: this,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.elasticOut,
            ),
          ),
          child: Center(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dialog header
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).primaryColor,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Dialog content
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Text(
                        message,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    // Dialog actions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: showTwoActions
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.center,
                        children: [
                          if (showTwoActions) ...[
                            // Cancel button (No)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<AuthProvider>().setIsFetching(false);
                                    context.read<StoryProvider>().setIsFetching(false);
                                    onCancel!();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    foregroundColor: Colors.black87,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(cancelText ?? 'Cancel'),
                                ),
                              ),
                            ),
                          ],
                          
                          // OK button (Yes)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: showTwoActions ? 8 : 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<AuthProvider>().setIsFetching(false);
                                  context.read<StoryProvider>().setIsFetching(false);
                                  onOk();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(okText ?? 'OK'),
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
        );
      },
    );
  }
}