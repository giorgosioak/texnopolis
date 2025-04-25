// screens/now_showing_screen.dart
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../widgets/movie_card.dart';
import 'movie_detail_screen.dart';

class NowShowingScreen extends StatelessWidget {
  const NowShowingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Now Showing')),
      body: FutureBuilder<List<Movie>>(
        future: ApiService.fetchNowShowingMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies available.'));
          }
          final movies = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,  // 2 items per row
              crossAxisSpacing: 8.0,  // Space between columns
              mainAxisSpacing: 16.0,  // Space between rows, increased to fit larger cards
              childAspectRatio: (1800 / 2400),
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to the MovieDetailScreen when the movie card is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  );
                },
                child: MovieCard(movie: movie),  // MovieCard widget
              );
            },
          );
        },
      ),
    );
  }
}
