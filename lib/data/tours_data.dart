import '../models/tour.dart';

final List<Tour> tours = [
  Tour(
    name: "Moso Island Cruise",
    description:
        "A relaxing day cruise with opportunities for kayaking and beach BBQ.",
    imageUrl: "assets/images/moso_island_cruise.jpg",
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
  Tour(
    name: "Nguna Island Tours",
    description:
        "An offshore Island of Efate with an extinct volcano crater. Home to the national annual event called the 'Taleva Run'..",
    imageUrl: "assets/images/taleva_run.jpg",
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
  Tour(
    name: "Round Island Day Trip",
    description:
        "Explore all the famous and most attractive spots around Efate Island.",
    imageUrl: "assets/images/efate_island.jpeg",
    openingHours: "8:00 AM - 4:00 PM",
    entryFee: "40000 VUV",
    duration: "6 hours",
    skipLine: true,
    pickupAvailable: true,
    rating: 4.3,
    reviews: 400,
    price: "\$400",
    isFavorite: false,
  ),
  // Add more tours here...
];
