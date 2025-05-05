import 'package:flutter/material.dart';

class StoryCard extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double lat;
  final double lon;
  final Function onTapped;

  const StoryCard({
    Key? key,
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
    required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        // make the card clickable
        onTap: () => onTapped(),
        child: Column(
          children: [
            Image.network(
              photoUrl,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CircularProgressIndicator();
              },
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.error,
                color: Colors.red,
              ),
            ),
            ListTile(
              title: Text(name),
              subtitle: Text(description),
            ),
          ],
        ),
      ),
    );
  }
}
