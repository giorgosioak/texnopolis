import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/offer.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;

  const OfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CachedNetworkImage(imageUrl: offer.image),
          ListTile(
            title: Text(offer.title),
            subtitle: Text(offer.description),
          ),
        ],
      ),
    );
  }
}
