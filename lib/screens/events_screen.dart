import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:texnopolis/widgets/event_card_list.dart';
import '../models/event.dart';
import '../services/api_service.dart';
import '../widgets/event_card.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
  }

  class _EventsScreenState extends State<EventsScreen> {
  bool isGridView = false;

  // Toggle between grid and list layout
  void _toggleLayout() {
  setState(() {
  isGridView = !isGridView;
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(AppLocalizations.of(context)!.events),centerTitle: true),
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.events),centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            onPressed: _toggleLayout,
          ),
        ],),
      body: FutureBuilder<List<Event>>(
        future: ApiService.fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events available.'));  // TODO
          }
          final events = snapshot.data!;
          // return ListView.builder(
          //   itemCount: events.length,
          //   itemBuilder: (context, index) => EventCard(event: events[index]),
          // );
          return isGridView
            ? _buildGridView(events)
            : _buildListView(events);
        },
      ),
    );
  }
  // GridView layout
  Widget _buildGridView(List<Event> events) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 items per row
        crossAxisSpacing: 8.0, // Space between columns
        mainAxisSpacing: 16.0, // Space between rows, increased to fit larger cards
        childAspectRatio: (1800 / 2400), // Aspect ratio for images
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => MovieDetailScreen(movie: event),
            //   ),
            // );
          },
          child: EventCard(event: event), // Grid card widget
        );
      },
    );
  }

  // ListView layout
  Widget _buildListView(List<Event> events) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => MovieDetailScreen(movie: movie),
            //   ),
            // );
          },
          child: EventCardList(event: event),  // Using the new custom card
        );
      },
    );
  }
}
