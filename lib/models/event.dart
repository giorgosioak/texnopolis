import 'package:html_unescape/html_unescape.dart';

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
    var unescape = HtmlUnescape();
    return Event(
      id: json['id'].toString() ?? '',
      title: unescape.convert(json['title'] ?? ''),
      image: json['image'] ?? '',
      description: unescape.convert(json['description'] ?? ''),
    );
  }
}
