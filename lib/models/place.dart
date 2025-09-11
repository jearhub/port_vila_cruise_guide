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

  // Factory for deserialization from JSON response
  factory Place.fromJson(Map<String, dynamic> json, String apiKey) {
    return Place(
      id: json['place_id'] ?? '', // Google Places returns 'place_id'
      name: json['name'] ?? '',
      description: json['formatted_address'] ?? '', // or adjust as needed
      imageUrl:
          (json['photos'] != null && (json['photos'] as List).isNotEmpty)
              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${json['photos'][0]['photo_reference']}&key=$apiKey'
              : '',
      rating:
          (json['rating'] != null)
              ? (json['rating'] is int)
                  ? (json['rating'] as int).toDouble()
                  : (json['rating'] as double)
              : 0.0,
      reviews: json['user_ratings_total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'rating': rating,
    'reviews': reviews,
  };
}
