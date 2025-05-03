import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black12, // Brown "stroke" background
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(4), // Creates the inner border effect
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7.5), // Slightly smaller to reveal stroke
            child: CachedNetworkImage(
              imageUrl: event.image,
              fit: BoxFit.cover, // Ensures image zooms and crops to fit the aspect ratio
              width: double.infinity, // Make sure the image takes the full width of the container
            ),
          ),
          if (event.kidsOk)
            Positioned(
              top: 8.0,
              right: 8.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.child_friendly,
                    size: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}