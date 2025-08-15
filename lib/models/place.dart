class Place {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviews;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
  });

  factory Place.fromJson(Map<String, dynamic> json, String apiKey) {
    String imageUrl = '';
    if (json['photos'] != null && (json['photos'] as List).isNotEmpty) {
      final photoRef = json['photos'][0]['photo_reference'];
      imageUrl =
          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoRef&key=$apiKey';
    }
    return Place(
      id: json['place_id'] ?? '',
      name: json['name'] ?? '',
      description: json['formatted_address'] ?? '',
      imageUrl: imageUrl,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: json['user_ratings_total'] ?? 0,
    );
  }
}
