import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/movie.dart';
import 'package:intl/intl.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isExpanded = false;
  final int _maxLength = 200;

  @override
  Widget build(BuildContext context) {
    // Group shows by room name
    final Map<String, List<Show>> groupedShows = {};
    for (var show in widget.movie.shows) {
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
              Center(
                  child: Text(
                  widget.movie.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  // Genre Icon
                  Icon(
                    // Icons.movie_creation, // Genre icon (can be customized based on your needs)
                    widget.movie.genreIcon,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.movie.genre,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  // Spacer to add space between the icons
                  const Spacer(),

                  // Time Icon + Length of movie
                  Icon(
                    Icons.access_time, // Clock icon for time
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.movie.length} min', // Length of movie
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

              const SizedBox(height: 8.0),

              // 📜 Description
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: _isExpanded
                          ? widget.movie.movieContent
                          : _shortenedDescription,
                    ),
                    if (widget.movie.movieContent.length > _maxLength &&
                        !_isExpanded)
                      TextSpan(
                        text: 'Read More',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              _isExpanded = true;
                            });
                          },
                      ),
                    if (widget.movie.movieContent.length > _maxLength &&
                        _isExpanded)
                      TextSpan(
                        text: ' Read Less',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              _isExpanded = false;
                            });
                          },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 8.0),

              // 🎬 Director, Cast, Length
              if (widget.movie.director.isNotEmpty)
                _buildMovieDetail(context, 'Director', widget.movie.director),

              if (widget.movie.actors.isNotEmpty)
                _buildMovieDetail(context, 'Cast', widget.movie.actors),

              // Group for the ticket and trailer URLs
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [


                    // Trailer URL Button with Icon and Text
                    TextButton.icon(
                      icon: const Icon(Icons.ondemand_video_rounded), // Trailer icon
                      label: const Text('Trailer'),
                      onPressed: () {
                        launchUrl(Uri.parse(widget.movie.trailer));
                      },
                    ),

                    const SizedBox(width: 16),

                    // Ticket URL Button with Icon and Text
                    TextButton.icon(
                      icon: const Icon(Icons.local_activity_rounded), // Ticket icon
                      label: const Text('Tickets'),
                      onPressed: () {
                        launchUrl(Uri.parse('https://tickets.texnopolis.net/#/spectacle/${widget.movie.spectacleId}'));
                      },
                    ),
                  ],
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieDetail(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // Slightly more bottom padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the top
        children: [
          Expanded(
            flex: 2, // Adjust flex values to control width ratio
            child: Text(
              '$title:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary, // Use a theme color
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            flex: 5,
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShowtimeGroupCard(
    BuildContext context,
    String roomName,
    List<Show> shows,
  ) {
    shows.sort((a, b) => a.timeslots.first.compareTo(
        b.timeslots.first)); // sort chronologically by the first timeslot

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Loop through each timeslot
                  for (var timeslot in show.timeslots) ...[
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16.0, color: Colors.grey),
                        const SizedBox(width: 6.0),
                        Text(
                          _formatShowtime(timeslot),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                  ],
                ],
              ),
            ],

            const SizedBox(height: 8.0),

            // Shared features (assumes same flags for all timeslots in the room)
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
  // String get _shortenedDescription {
  //   if (widget.movie.movieContent.length <= _maxLength) {
  //     return widget.movie.movieContent;
  //   } else {
  //     final shortened = widget.movie.movieContent.substring(0, _maxLength);
  //     final lastSentenceEnd = shortened.lastIndexOf(RegExp(r'[.!;?]'));
  //     if (lastSentenceEnd > 0 && lastSentenceEnd < shortened.length - 10) {
  //       return '${widget.movie.movieContent.substring(0, lastSentenceEnd + 1)} ';
  //     } else {
  //       return '$shortened... ';
  //     }
  //   }
  // }

  String get _shortenedDescription {
    if (widget.movie.movieContent.length <= _maxLength) {
      return widget.movie.movieContent;
    } else {
      return '${widget.movie.movieContent.substring(0, _maxLength)}... ';
    }
  }

  String _formatShowtime(DateTime timeslot) {
    final formattedDate = DateFormat('EEE, MMM d').format(timeslot);
    final formattedTime = DateFormat.jm().format(timeslot);
    return '$formattedDate – $formattedTime';
  }
}
