class Event {
  final String id;
  final String title;
  final String image;
  final String description;

  Event({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'].toString() ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
