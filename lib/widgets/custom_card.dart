import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/movie.dart';

class CustomMovieCard extends StatelessWidget {
  final Movie movie;

  const CustomMovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 5.0,
      child: Row(
        children: [
          // Left side: Movie image with aspect ratio
          Padding( // Add a Padding widget here
          padding: const EdgeInsets.all(8.0), // Specify the left padding
            child: SizedBox(
              width: 100,  // Set the width here for the image
              child: AspectRatio(
                aspectRatio: 1800 / 2400, // Keep the aspect ratio intact
                child: ClipRRect( // Wrap the Image.network with ClipRRect
                  borderRadius: BorderRadius.circular(10), // Set the desired border radius
                    child: Image.network(
                      movie.image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      },
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
                  Text(
                    movie.genre,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  if (movie.showsForToday.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Showing today:",
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
