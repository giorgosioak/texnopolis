import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../widgets/custom_card.dart';
import '../widgets/movie_card.dart'; // Make sure this is defined properly for both layouts
import 'movie_detail_screen.dart';

class NowShowingScreen extends StatefulWidget {
  const NowShowingScreen({super.key});

  @override
  _NowShowingScreenState createState() => _NowShowingScreenState();
}

class _NowShowingScreenState extends State<NowShowingScreen> {
  // A boolean variable to track whether we are in grid or list view
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
      appBar: AppBar(
        title: const Text('Προβάλλονται τώρα'),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            onPressed: _toggleLayout,
          ),
        ],
      ),
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
          return isGridView
              ? _buildGridView(movies)
              : _buildListView(movies);
        },
      ),
    );
  }

  // GridView layout
  Widget _buildGridView(List<Movie> movies) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 items per row
        crossAxisSpacing: 8.0, // Space between columns
        mainAxisSpacing: 16.0, // Space between rows, increased to fit larger cards
        childAspectRatio: (1800 / 2400), // Aspect ratio for images
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie: movie),
              ),
            );
          },
          child: MovieCard(movie: movie), // Grid card widget
        );
      },
    );
  }

  // ListView layout
  Widget _buildListView(List<Movie> movies) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie: movie),
              ),
            );
          },
          child: CustomMovieCard(movie: movie),  // Using the new custom card
        );
      },
    );
  }
}
