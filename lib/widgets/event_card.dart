import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CachedNetworkImage(imageUrl:event.image),
          ListTile(
            title: Text(event.title),
            subtitle: Text(event.description),
          ),
        ],
      ),
    );
  }
}
