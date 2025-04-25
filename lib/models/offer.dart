class Offer {
  final String id;
  final String title;
  final String image;
  final String description;

  Offer({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'].toString() ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
    );
  }
}