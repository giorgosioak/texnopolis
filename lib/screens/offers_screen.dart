import 'package:flutter/material.dart';
import '../models/offer.dart';
import '../services/api_service.dart';
import '../widgets/offer_card.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offers')),
      body: FutureBuilder<List<Offer>>(
        future: ApiService.fetchOffers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No offers available.'));
          }
          final offers = snapshot.data!;
          return ListView.builder(
            itemCount: offers.length,
            itemBuilder: (context, index) => OfferCard(offer: offers[index]),
          );
        },
      ),
    );
  }
}
