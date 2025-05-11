import 'package:flutter/material.dart';

class UnknownScreen extends StatefulWidget {
  final Function() backHome;
  const UnknownScreen({super.key, required this.backHome});

  static const String routeName = '/unknown';

  @override
  State<UnknownScreen> createState() => _UnknownScreenState();
}

class _UnknownScreenState extends State<UnknownScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE1F5FE), Color(0xFFB3E5FC)],
                ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated 404 text
              Text(
                '404',
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.blueGrey[800],
                  fontFamily: 'Poppins',
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: isDark ? Colors.black54 : Colors.white54,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Creative illustration (using Flutter's built-in icons)
              Icon(
                Icons.explore_off_rounded,
                size: 120,
                color: isDark ? Colors.blueGrey[300] : Colors.blueGrey[600],
              ),
              const SizedBox(height: 30),

              // Main message
              Text(
                'Lost in Space!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.blueGrey[800],
                ),
              ),
              const SizedBox(height: 15),

              // Sub message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'The page you\'re looking for doesn\'t exist or has been moved to another galaxy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : Colors.blueGrey[600],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.blue[800] : Colors.blue[600],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  widget.backHome();
                },
                child: const Text(
                  'Beam Me Home',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
