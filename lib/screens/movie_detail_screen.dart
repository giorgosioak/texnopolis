import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/movie.dart';
import 'package:intl/intl.dart';

import '../utils/time.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isExpanded = false;
  final int _maxLength = 200;
  final next7Days = Time.getNext7Days();

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
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    // Genre Icon
                    Icon(
                      // Icons.movie_creation, // Genre icon (can be customized based on your needs)
                      widget.movie.genreIcon,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
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
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.movie.length} min', // Length of movie // TODO
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),

                const SizedBox(height: 16.0),

                // 📜 Description
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
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
                          text: ' ${AppLocalizations.of(context)!.readMore}',
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
                          text: ' ${AppLocalizations.of(context)!.readLess}',
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

                const SizedBox(height: 16.0),

                // 🎬 Director, Cast, Length
                if (widget.movie.director.isNotEmpty)
                  _buildMovieDetail(context, AppLocalizations.of(context)!.director, widget.movie.director),

                if (widget.movie.actors.isNotEmpty)
                  _buildMovieDetail(context, AppLocalizations.of(context)!.cast, widget.movie.actors),

                // Group for the ticket and trailer URLs
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Trailer URL Button with Icon and Text
                      TextButton.icon(
                        icon: const Icon(
                            Icons.ondemand_video_rounded), // Trailer icon
                        label: Text(AppLocalizations.of(context)!.trailer),
                        onPressed: () {
                          launchUrl(Uri.parse(widget.movie.trailer));
                        },
                      ),

                      const SizedBox(width: 16),

                      // Ticket URL Button with Icon and Text
                      TextButton.icon(
                        icon: const Icon(
                            Icons.local_activity_rounded), // Ticket icon
                        label: Text(AppLocalizations.of(context)!.tickets),
                        onPressed: () {
                          launchUrl(Uri.parse(
                              'https://tickets.texnopolis.net/#/spectacle/${widget.movie.spectacleId}'));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),

                if (widget.movie.shows.isNotEmpty)
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.sevenDayScreenings,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                  ),

                if (widget.movie.shows.isNotEmpty) const SizedBox(height: 8.0),

                if (widget.movie.shows.isNotEmpty)
                  // Display screenings for the next 7 days
                  for (var date in next7Days)
                    if (widget.movie.showsPerDay(date).isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display the date heading (Day, Month Date)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0), // Add top padding for the date
                            child: Text(
                              DateFormat('EEEE d/M').format(date),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                          ),

                          // Add a small space after the date
                          const SizedBox(height: 8.0),

                          // For each screening on this date, display the screenings and timeslots
                          for (var screening in widget.movie.showsPerDay(date))
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0), // Space between screenings
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(screening.title),

                                  // Add space between title and timeslots
                                  const SizedBox(height: 8.0),

                                  // Create a Row of timeslots (3 per row)
                                  Wrap(
                                    spacing: 8.0, // Space between the cards
                                    runSpacing: 8.0, // Space between rows
                                    children: [
                                      for (var slot in screening.timeslots)
                                        SizedBox(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  48) /
                                              3, // 3 items per row
                                          child: Card(
                                            elevation: 0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  DateFormat('h:mm a')
                                                      .format(slot),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
              ],
            ),
          ),
        ));
  }

  Widget _buildMovieDetail(BuildContext context, String title, String content) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 12.0), // Slightly more bottom padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the top
        children: [
          Expanded(
            flex: 2, // Adjust flex values to control width ratio
            child: Text(
              '$title:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary, // Use a theme color
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


  String get _shortenedDescription {
    if (widget.movie.movieContent.length <= _maxLength) {
      return widget.movie.movieContent;
    } else {
      return '${widget.movie.movieContent.substring(0, _maxLength)}...';
    }
  }


}
