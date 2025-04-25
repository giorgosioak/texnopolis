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
  final List<String> actors;
  final int length;
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
    required this.shows,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      imageFull: json['image_full'] ?? '',
      kidsOk: json['kids_ok'] ?? false,
      movieContent: json['movie_content'] ?? '',
      trailer: json['trailer'] ?? '',
      genre: json['genre'] ?? '',
      director: json['director'] ?? '',
      // Ensure actors is always a list of strings
      actors: (json['actors'] is List)
          ? List<String>.from(json['actors'])  // Explicitly convert List<dynamic> to List<String>
          : [],
      length: int.tryParse(json['length']?.toString() ?? '0') ?? 0,
      shows: (json['shows'] != null && json['shows'] is List)
          ? (json['shows'] as List).map((showJson) => Show.fromJson(showJson)).toList()
          : [], // Handle null or invalid shows
    );
  }
}

class Show {
  final String id;
  final String title;
  final String timeslot;
  final bool is3D;
  final bool isCovidFree;

  Show({
    required this.id,
    required this.title,
    required this.timeslot,
    required this.is3D,
    required this.isCovidFree,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      id: json['ID'].toString(),
      title: json['post_title'] ?? '',
      // Ensure that timeslots is a valid list and access the first one
      timeslot: (json['timeslots'] != null && json['timeslots'] is List && json['timeslots'].isNotEmpty)
          ? json['timeslots'][0]['date'] ?? ''
          : '',
      is3D: (json['timeslots'] != null && json['timeslots'] is List && json['timeslots'].isNotEmpty)
          ? json['timeslots'][0]['is3D'] ?? false
          : false,
      isCovidFree: (json['timeslots'] != null && json['timeslots'] is List && json['timeslots'].isNotEmpty)
          ? json['timeslots'][0]['isCovidFree'] ?? false
          : false,
    );
  }
}
