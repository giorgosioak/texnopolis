import 'package:flutter/material.dart';

class Movie {
  final String id;
  final String title;
  final String image;
  final String imageFull;
  final bool kidsOk;
  final String movieContent;
  final String trailer;
  final String genre;
  final String director;
  final String actors;
  final int length;
  final String spectacleId;
  final List<Show> shows;

  Movie({
    required this.id,
    required this.title,
    required this.image,
    required this.imageFull,
    required this.kidsOk,
    required this.movieContent,
    required this.trailer,
    required this.genre,
    required this.director,
    required this.actors,
    required this.length,
    required this.spectacleId,
    required this.shows,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      imageFull: json['image_full'] ?? '',
      kidsOk: json['kids_ok'] ?? false,
      movieContent: json['movie_content'].replaceAll(RegExp(r'<[^>]*>'), '') ?? '',
      trailer: json['trailer'] ?? '',
      genre: json['genre'] ?? '',
      director: json['director'] ?? '',
      // Ensure actors is always a list of strings
      actors: json['actors'],
      length: int.tryParse(json['length']?.toString() ?? '0') ?? 0,
      spectacleId: json['spectacle_id'] ?? '',
      shows: (json['shows'] != null && json['shows'] is List)
          ? List<Show>.from((json['shows'] as List).map((showJson) => Show.fromJson(showJson)))
          : [], // Handle null or invalid shows
    );
  }

  List<Show> get showsForToday {
    DateTime today = DateTime.now();
    return showsPerDay(today);
  }
  List<Show> showsPerDay(DateTime dt) {
    List<Show> filteredShows = [];
    for (var show in shows) {
      List<DateTime> filteredTimeslots = List.from(show.timeslots);
      filteredTimeslots.removeWhere((timeslot) {
        return timeslot.year != dt.year ||
            timeslot.month != dt.month ||
            timeslot.day != dt.day;
      });
      if (filteredTimeslots.isNotEmpty) {
        filteredShows.add(Show(
          id: show.id,
          title: show.title,
          timeslots: filteredTimeslots,
          is3D: show.is3D,
          isCovidFree: show.isCovidFree,
        ));
      }
    }

    return filteredShows;
  }

  IconData get genreIcon {
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
        return Icons.toys;
      case 'Οικογενειακή':
      case 'Παιδική Οικογενειακή':
      case 'Παιδική/Οικογενειακή':
        return Icons.family_restroom;
      default:
        return Icons.movie;
    }
  }
}

class Show {
  final String id;
  final String title;
  final List<DateTime> timeslots; // List of DateTime objects
  final bool is3D;
  final bool isCovidFree;

  Show({
    required this.id,
    required this.title,
    required this.timeslots,
    required this.is3D,
    required this.isCovidFree,
  });

  // Factory constructor for JSON parsing
  factory Show.fromJson(Map<String, dynamic> json) {
    try {
      // Parse all timeslots
      List<DateTime> parsedTimeslots = [];
      if (json['timeslots'] != null) {
        for (var timeslotData in json['timeslots']) {
          parsedTimeslots.add(DateTime.parse(timeslotData['date']));
        }
      }

      return Show(
        id: json['id'].toString(),
        title: json['post_title'] ?? 'Unknown Title',
        timeslots: parsedTimeslots,
        is3D: json['timeslots'] != null && json['timeslots'].isNotEmpty
            ? json['timeslots'][0]['is3D'] ?? false
            : false,
        isCovidFree: json['timeslots'] != null && json['timeslots'].isNotEmpty
            ? json['timeslots'][0]['isCovidFree'] ?? false
            : false,
      );
    } catch (e) {
      print('Error parsing show: $e');
      return Show(
        id: '0',
        title: 'Error',
        timeslots: [],
        is3D: false,
        isCovidFree: false,
      );
    }
  }
}

