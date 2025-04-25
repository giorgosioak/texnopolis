import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'package:intl/intl.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    // Group shows by room name
    final Map<String, List<Show>> groupedShows = {};
    for (var show in movie.shows) {
      groupedShows.putIfAbsent(show.title, () => []).add(show);
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🎬 Movie title
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              const SizedBox(height: 8.0),

              // 🎭 Genre
              Text(
                movie.genre,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16.0),

              // 📜 Description
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    movie.movieContent,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // 🎬 Director, Cast, Length
              _buildMovieDetail(context, 'Director', movie.director),
              _buildMovieDetail(context, 'Cast', movie.actors.join(', ')),
              _buildMovieDetail(context, 'Length', '${movie.length} min'),
              const SizedBox(height: 16.0),

              // ⏰ Showtimes grouped by room
              if (groupedShows.isNotEmpty) ...[
                const Text(
                  'Showtimes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                for (var entry in groupedShows.entries)
                  _buildShowtimeGroupCard(context, entry.key, entry.value),
                const SizedBox(height: 16.0),
              ],

              // ▶️ Watch Trailer
              if (movie.trailer.isNotEmpty)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Use 'url_launcher' to open the trailer URL
                      // launch(movie.trailer);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Watch Trailer'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieDetail(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        '$title: $content',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildShowtimeGroupCard(
      BuildContext context,
      String roomName,
      List<Show> shows,
      ) {
    shows.sort((a, b) => a.timeslot.compareTo(b.timeslot)); // sort chronologically

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$roomName',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
              ),
            ),
            const SizedBox(height: 12.0),

            // Showtimes
            for (var show in shows) ...[
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16.0, color: Colors.grey),
                  const SizedBox(width: 6.0),
                  Text(
                    _formatShowtime(show.timeslot),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
            ],

            const SizedBox(height: 8.0),

            // Shared features (assumes same flags)
            Text(
              '3D: ${shows.first.is3D ? 'Yes' : 'No'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'COVID Free: ${shows.first.isCovidFree ? 'Yes' : 'No'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _formatShowtime(String timeslot) {
    final dateTime = DateTime.parse(timeslot);
    final formattedDate = DateFormat('EEE, MMM d').format(dateTime);
    final formattedTime = DateFormat.jm().format(dateTime);
    return '$formattedDate – $formattedTime';
  }
}
