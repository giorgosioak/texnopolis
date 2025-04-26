import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/movie.dart';

class NowShowingListCard extends StatelessWidget {
  final Movie movie;

  const NowShowingListCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      // elevation: 5.0,
      child: Row(
        children: [
          // Left side: Movie image with aspect ratio
          Padding( // Add a Padding widget here
          padding: const EdgeInsets.all(8.0), // Specify the left padding
            child: SizedBox(
              width: 100,  // Set the width here for the image
              child: AspectRatio(
                aspectRatio: 1800 / 2400, // Keep the aspect ratio intact
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Set the desired border radius
                  child: CachedNetworkImage(
                    imageUrl: movie.image,
                    fit: BoxFit.cover,
                    // placeholder: (context, url) => const Center(
                    //   child: CircularProgressIndicator(),
                    // ),
                    // errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
          // Right side: Movie title, genre, and showtimes
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  // Text(
                  //   movie.genre,
                  //   style: Theme.of(context).textTheme.titleSmall,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  Row(children: [
                    // Genre Icon
                    Icon(
                      // Icons.movie_creation, // Genre icon (can be customized based on your needs)
                      movie.genreIcon,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      movie.genre,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ]),
                  const SizedBox(height: 16.0),
                  if (movie.showsForToday.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Προβολές Σήμερα:",
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        ...movie.showsForToday.map((show) {
                          RegExp regExp = RegExp(r'Αίθουσα\s([0-9A-ZΑ-Ω])');
                          var match = regExp.firstMatch(show.title);
                          String movieRoom = match != null ? "Αίθ. ${match.group(1)}" : show.title;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text( "$movieRoom: ${show.timeslots.map((timeslot) {
                                  return DateFormat('hh:mm a').format(timeslot);
                                }).join(', ')}"
                              )
                            ],
                          );
                        }),
                      ],
                    )
                  else
                    Text(
                      "No shows today.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
