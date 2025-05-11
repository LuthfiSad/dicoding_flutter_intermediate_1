import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
                Theme.of(context).primaryColor, // primary color
              Colors.white,      // white
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated logo/icon
              const Icon(
                Icons.travel_explore,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 30),
              
              // App name with creative typography
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, Color(0xFF00F5FF)],
                ).createShader(bounds),
                child: const Text(
                  'StoryMap',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                ),
              ),
              
              // Tagline
              const SizedBox(height: 15),
              const Text(
                'Share Your Journey, Pin Your Story',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
              
              // Loading indicator at the bottom
              const SizedBox(height: 50),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}