import 'package.dart';
import 'bookable_item.dart';

class Attraction implements BookableItem {
  final String name;
  final String description;
  final String imageUrl;
  final String openingHours;
  final String entryFee;
  final String duration;
  final bool skipLine;
  final bool pickupAvailable;
  final double rating;
  final int reviews;
  final String address;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final String price;
  final List category;
  final bool isFavorite;
  final List<Package>? packages;

  const Attraction({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.openingHours,
    required this.entryFee,
    required this.duration,
    required this.skipLine,
    required this.pickupAvailable,
    required this.rating,
    required this.reviews,
    required this.address,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.price,
    required this.category,
    this.isFavorite = false,
    this.packages,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'openingHours': openingHours,
    'entryFee': entryFee,
    'duration': duration,
    'skipLine': skipLine,
    'pickupAvailable': pickupAvailable,
    'rating': rating,
    'reviews': reviews,
    'address': address,
    'phoneNumber': phoneNumber,
    'latitude': latitude,
    'longitude': longitude,
    'price': price,
    'category': category,
    'isFavorite': isFavorite,
    'packages': packages?.map((p) => p.toJson()).toList(),
  };

  factory Attraction.fromFirestore(dynamic doc) {
    final data = doc.data() as Map;
    return Attraction(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      openingHours: data['openingHours'] ?? '',
      entryFee: data['entryFee'] ?? '',
      duration: data['duration'] ?? '',
      skipLine: data['skipLine'] ?? false,
      pickupAvailable: data['pickupAvailable'] ?? false,
      rating:
          (data['rating'] is int)
              ? (data['rating'] as int).toDouble()
              : (data['rating'] ?? 0.0),
      reviews: data['reviews'] ?? 0,
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      latitude:
          (data['latitude'] is int)
              ? (data['latitude'] as int).toDouble()
              : (data['latitude'] ?? 0.0),
      longitude:
          (data['longitude'] is int)
              ? (data['longitude'] as int).toDouble()
              : (data['longitude'] ?? 0.0),
      price: data['price'] ?? '',
      category: List.from(data['category'] ?? []),
      isFavorite: data['isFavorite'] ?? false,
      packages:
          (data['packages'] != null)
              ? (data['packages'] as List)
                  .map((p) => Package.fromJson(Map.from(p)))
                  .toList()
              : null,
    );
  }
}
