import 'package:flutter/foundation.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';

class Event {
  final String id;
  final String title;
  final String image;
  final String description;
  final String? theaterName;
  final DateTime? eventDate;
  final String? summary;
  final String? eventContent;
  final bool kidsOk;

  Event({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    this.theaterName,
    this.eventDate,
    this.summary,
    this.eventContent,
    this.kidsOk = false,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    var unescape = HtmlUnescape();
    String? eventDateString = json['eventDate'];

    // Parse eventDate if it's not null and matches the expected format (e.g., "dd/MM")
    DateTime? eventDate;
    if (eventDateString != null && eventDateString.isNotEmpty) {
      try {
        // Try parsing the date, assuming it is in the "dd/MM" format
        eventDate = DateFormat('dd/MM').parse(eventDateString);
      } catch (e) {
        // If parsing fails, print an error or handle it
        if (kDebugMode) {
          print('Error parsing event date: $e');
        }
      }
    }

    return Event(
      id: json['id'].toString(),
      title: unescape.convert(json['title'] ?? ''),
      image: json['image'] ?? '',
      description: unescape.convert(json['description'] ?? ''),
      theaterName: json['theater']?['post_title'] != null
          ? unescape.convert(json['theater']['post_title'])
          : null,
      eventDate: eventDate,
      summary: unescape.convert(json['summary'] ?? ''),
      eventContent: json['event_content'],
      kidsOk: json['kids_ok'] ?? false,
    );
  }
}
