import '../models/attraction.dart';

final List<Attraction> attractions = [
  Attraction(
    name: "Port Vila: Pepeyo, Blue Lagoon & Eden Tour",
    description:
        "A full-day tour including Pepeyo Cultural Village, Blue Lagoon, and Eden on the River.",
    imageUrl: "assets/images/blue_lagoon.jpg",
    openingHours: "8:00 AM - 4:00 PM",
    entryFee: "1000 VUV",
    duration: "6 hours",
    skipLine: true,
    pickupAvailable: true,
    rating: 4.3,
    reviews: 110,
    price: "\$103",
    isFavorite: false,
  ),
  Attraction(
    name: "Mele Cascades Waterfalls",
    description:
        "A stunning waterfall with natural pools perfect for swimming.",
    imageUrl: "assets/images/cascades_waterfall.jpg",
    openingHours: "8:00 AM - 4:00 PM",
    entryFee: "500 VUV",
    duration: "3 hours",
    skipLine: false,
    pickupAvailable: true,
    rating: 4.7,
    reviews: 85,
    price: "\$75",
    isFavorite: true,
  ),
  Attraction(
    name: "Hideaway Island",
    description:
        "Famous for its underwater post office and vibrant coral reefs.",
    imageUrl: "assets/images/hideaway_island.jpg",
    openingHours: "8:00 AM - 4:00 PM",
    entryFee: "12000 VUV",
    duration: "6 hours",
    skipLine: false,
    pickupAvailable: true,
    rating: 4.8,
    reviews: 100,
    price: "\$150",
    isFavorite: false,
  ),
  // Add more attractions here...
];
