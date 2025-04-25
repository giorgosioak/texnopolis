import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black12, // Brown "stroke" background
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(4), // Creates the inner border effect
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7.5), // Slightly smaller to reveal stroke
            child: Image.network(
              movie.image,
              fit: BoxFit.cover, // Ensures image zooms and crops to fit the aspect ratio
              width: double.infinity, // Make sure the image takes the full width of the container
            ),
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5), // Semi-transparent background for icon visibility
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  _getMovieTypeIcon(movie.genre),
                  size: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMovieTypeIcon(String genre) {
    switch (genre.trim()) {
      case 'Φαντασίας':
      case 'Περιπέτεια Φαντασίας':
        return Icons.auto_awesome;
      case 'Περιπέτεια':
      case 'Περιπέτεια Μυστηρίου':
      case 'Κωμική Περιπέτεια':
        return Icons.explore;
      case 'Θρίλερ':
        return Icons.bolt;
      case 'Μουσική-Βιογραφική':
      case 'Μουσικό Ντοκυμαντέρ':
        return Icons.music_note;
      case 'Κινούμενα Σχέδια':
        return Icons.animation;
      case 'Οικογενειακή':
      case 'Παιδική Οικογενειακή':
      case 'Παιδική/Οικογενειακή':
        return Icons.family_restroom;
      default:
        return Icons.movie;
    }
  }
}

//
//
//
//
// @override
// Widget build(BuildContext context) {
//   return Stack(
//     children: [
//       Container(
//         margin: const EdgeInsets.all(8.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.only(
//             topRight: Radius.circular(10),
//             bottomLeft: Radius.circular(10),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 6,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             // Movie Poster
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(10),
//                 topLeft: Radius.circular(10),
//               ),
//               child: Image.network(
//                 movie.image,
//                 height: 150,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             // const SizedBox(height: 8.0),
//
//             // Title
//             // Padding(
//             //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             //   child: Text(
//             //     movie.title,
//             //     maxLines: 1,
//             //     overflow: TextOverflow.ellipsis,
//             //     style: Theme.of(context)
//             //         .textTheme
//             //         .bodyLarge
//             //         ?.copyWith(fontWeight: FontWeight.bold),
//             //   ),
//             // ),
//             // const SizedBox(height: 4.0),
//
//             // Genre
//             // Padding(
//             //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             //   child: Text(
//             //     movie.genre,
//             //     maxLines: 1,
//             //     overflow: TextOverflow.ellipsis,
//             //     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//             //       color: Colors.grey[700],
//             //       fontStyle: FontStyle.italic,
//             //     ),
//             //   ),
//             // ),
//             // const SizedBox(height: 12.0),
//           ],
//         ),
//       ),
//
//       // Top-right genre icon
//       Positioned(
//         top: 12,
//         right: 12,
//         child: _buildMovieTypeIcon(movie.genre),
//       ),
//     ],
//   );
// }
//
// Widget _buildMovieTypeIcon(String genre) {
//   IconData iconData;
//   Color iconColor;
//
//   switch (genre.trim()) {
//     case 'Φαντασίας':
//     case 'Περιπέτεια Φαντασίας':
//       iconData = Icons.auto_awesome;
//       iconColor = Colors.deepPurpleAccent;
//       break;
//     case 'Περιπέτεια':
//     case 'Περιπέτεια Μυστηρίου':
//     case 'Κωμική Περιπέτεια':
//       iconData = Icons.explore;
//       iconColor = Colors.indigo;
//       break;
//     case 'Θρίλερ':
//       iconData = Icons.bolt;
//       iconColor = Colors.redAccent;
//       break;
//     case 'Μουσική-Βιογραφική':
//     case 'Μουσικό Ντοκυμαντέρ':
//       iconData = Icons.music_note;
//       iconColor = Colors.pinkAccent;
//       break;
//     case 'Κινούμενα Σχέδια':
//       iconData = Icons.animation;
//       iconColor = Colors.teal;
//       break;
//     case 'Οικογενειακή':
//     case 'Παιδική Οικογενειακή':
//     case 'Παιδική/Οικογενειακή':
//       iconData = Icons.family_restroom;
//       iconColor = Colors.orange;
//       break;
//     default:
//       iconData = Icons.movie;
//       iconColor = Colors.grey;
//   }
//
//   return CircleAvatar(
//     radius: 16,
//     backgroundColor: iconColor.withOpacity(0.15),
//     child: Icon(
//       iconData,
//       size: 18,
//       color: iconColor,
//     ),
//   );
// }
// }
