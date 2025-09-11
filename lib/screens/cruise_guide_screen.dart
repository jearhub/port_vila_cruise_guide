import 'package:VilaCruise/models/attraction.dart';
import 'package:VilaCruise/models/dining.dart';
import 'package:flutter/material.dart';
//import 'places_screen.dart';
import 'tours_screen.dart';
import 'package:weather/weather.dart';
import '../models/tour.dart';
import 'tour_detail_screen.dart';
//import 'custom_search_bar.dart' as custom_search_bar;
import '../widgets/deal_action_card.dart';
import '../secret.dart';
import 'local_info_screen.dart';
import 'self_guided_walk_tour_screen.dart';
import 'dining_screen.dart';
import 'shopping_screen.dart';
import 'beauty_care_screen.dart';
//import 'kids_space_screen.dart';
import 'transport_screen.dart';
import '../widgets/stroked_text.dart';
import 'attractions_screen.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'foreign_currency_screen.dart';
import '../models/package.dart';
import 'profile_screen.dart';
import 'attraction_detail_screen.dart';
import 'dining_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/cruise_schedule_card.dart';
import 'esim_screen.dart';

class CruiseGuideScreen extends StatefulWidget {
  const CruiseGuideScreen({Key? key}) : super(key: key);

  @override
  State createState() => _CruiseGuideScreenState();
}

class _CruiseGuideScreenState extends State<CruiseGuideScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const CruiseGuideHomeContent(),
      //const TransportScreen(),
      //ForeignCurrencyScreen(),
      const LocalInfoScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal.shade700,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Transport',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Currency',
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Info',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}

class CruiseGuideHomeContent extends StatefulWidget {
  const CruiseGuideHomeContent({Key? key}) : super(key: key);

  @override
  State createState() => _CruiseGuideHomeContentState();
}

class FloatMenu extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const FloatMenu({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use a horizontal ListView for spacing and responsiveness
    return SizedBox(
      height: 100, // Consistent with image aspect
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            items
                .map(
                  (item) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                        // <-- InkWell goes here
                        borderRadius: BorderRadius.circular(22),
                        splashColor: Colors.teal.withOpacity(0.23),
                        highlightColor: Colors.teal.withOpacity(0.13),
                        onTap: () {
                          if (item['screen'] != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => item['screen']),
                            );
                          }
                        },
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 6,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  item['icon'],
                                  color: Colors.teal,
                                  size: 30,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['label'],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class _CruiseGuideHomeContentState extends State<CruiseGuideHomeContent> {
  // Define the pikininibarAttraction variable (replace with actual Attraction type and data)
  final pikininibar = Attraction(
    name: "Pikinini Bar",
    description:
        "Childrens Day Special Offer - Haircut, Ice cream, Smoothie. For only VT 1,000",
    imageUrl: "assets/images/childrens_day.jpg",
    openingHours: "8:00 AM - 9:00 PM",
    entryFee: "1,000 VT",
    duration: "Varies",
    skipLine: false,
    pickupAvailable: false,
    rating: 4.5,
    reviews: 25,
    address: "Fatumaru Bay, Port Vila, Vanuatu",
    phoneNumber: "",
    latitude: -17.73390,
    longitude: 168.31130,
    price: "VT 1,000",
    category: [""],
    isFavorite: false,
    packages: null,
  );

  final banyanbar = Dining(
    name: 'Banyan Beach Bar & Restaurant',
    category: 'Dining',
    address: 'Lini Highway, Port Vila',
    description:
        'A beachfront bar and restaurant offering a mix of local and international cuisine.',
    imageUrl: 'assets/images/banyan.jpg',
    //website: 'facebook.com/banyanbeachbar',
    openingHours: '10:00 AM - 10:00 PM',
    rating: 4.0,
    reviews: 89,
    price: '\VT 1,500',
    menu: [],
    phoneNumber: '+678 7605268',
    latitude: -17.73096,
    longitude: 168.31129,
  );

  final List<Tour> thingsToDo = const [
    Tour(
      name: "Jungle Ziplining",
      description:
          "An exhilarating zipline adventure through the lush Vanuatu jungle.",
      imageUrl: "assets/images/zipline.jpg",
      openingHours: "8:00 AM - 4:00 PM",
      entryFee: "2000 VUV",
      duration: "4 hours",
      skipLine: true,
      pickupAvailable: true,
      rating: 4.3,
      reviews: 110,
      address: "Devil's Point Road, Mele, Port Vila, Vanuatu",
      phoneNumber: "+678 5550423",
      latitude: -17.68030,
      longitude: 168.23985,
      price: "\VT 2,000",
      category: ["Nature", "Adventure", "Family"],
      isFavorite: false,
      packages: [
        Package(
          name: 'Family Package',
          description:
              'Includes 4 tickets for families. Enjoy a special guided tour!',
          ticketsIncluded: 4,
          price: 'VT 7,000',
        ),
        Package(
          name: 'VIP Experience',
          description: 'Skip the line and enjoy special lounge access.',
          ticketsIncluded: 2,
          price: 'VT 3,000',
        ),
      ],
    ),
    Tour(
      name: 'Cultural Village Tour',
      description:
          'Experience the rich culture of Port Vila. Immerse yourself in local traditions and crafts.',
      imageUrl: 'assets/images/cultural_village.jpg',
      openingHours: '9:00 AM - 4:00 PM',
      entryFee: 'Included',
      duration: '4 hours',
      skipLine: false,
      pickupAvailable: true,
      rating: 4.5,
      reviews: 98,
      address: "Pepeyo Tours, Eratap Village, Vanuatu",
      phoneNumber: "",
      latitude: -17.77725,
      longitude: 168.42107,
      price: '\VT 5,000',
      category: [""],
      isFavorite: false,
      packages: [
        Package(
          name: 'Family Package',
          description:
              'Includes 4 tickets for families. Enjoy a special guided tour!',
          ticketsIncluded: 4,
          price: 'VT 18,000',
        ),
        Package(
          name: 'VIP Experience',
          description: 'Skip the line and enjoy special lounge access.',
          ticketsIncluded: 2,
          price: 'VT 8,000',
        ),
      ],
    ),
    Tour(
      name: 'Lagoon Cruise',
      description:
          'Kick back on a beautiful lagoon cruise, and indulge in a tasty lunch with Erakor Lagoon Cruise.',
      imageUrl: 'assets/images/lagoon_cruise.jpg',
      openingHours: '9:00 AM - 5:00 PM',
      entryFee: 'Included',
      duration: '3 hours',
      skipLine: true,
      pickupAvailable: true,
      rating: 4.7,
      reviews: 120,
      address: "Elluk Road, Port Vila, Vanuatu",
      phoneNumber: "+678 28000",
      latitude: -17.75327,
      longitude: 168.31751,
      price: '\VT 2,500',
      category: [""],
      isFavorite: false,
      packages: [
        Package(
          name: 'Family Package',
          description:
              'Includes 4 tickets for families. Enjoy a special guided tour!',
          ticketsIncluded: 4,
          price: 'VT 9,000',
        ),
        Package(
          name: 'VIP Experience',
          description: 'Skip the line and enjoy special lounge access.',
          ticketsIncluded: 2,
          price: 'VT 5,500',
        ),
      ],
    ),
    Tour(
      name: 'Waterfall Hike',
      description:
          'Hike to stunning waterfalls surrounded by nature. A refreshing experience. It\'s a great way to connect with nature and enjoy the outdoors.',
      imageUrl: 'assets/images/waterfall_hike.jpg',
      openingHours: '8:00 AM - 3:00 PM',
      entryFee: 'Free',
      duration: '5 hours',
      skipLine: false,
      pickupAvailable: false,
      rating: 4.8,
      reviews: 75,
      address: "Lololima Falls, Montmartre, Vanuatu",
      phoneNumber: "+678 22813",
      latitude: -17.72797,
      longitude: 168.38857,
      price: 'Free',
      category: ["+678 5538355"],
      isFavorite: false,
      packages: null,
    ),
    Tour(
      name: 'Market Shopping',
      description:
          'Shop for local crafts and souvenirs at the market. Have a chat with local artisans and learn about their crafts.',
      imageUrl: 'assets/images/market_shopping.jpg',
      openingHours: '7:00 AM - 6:00 PM',
      entryFee: 'Free',
      duration: '2 hours',
      skipLine: false,
      pickupAvailable: false,
      rating: 4.3,
      reviews: 60,
      address: "Rue Kalsakau Drive, Port Vila, Vanuatu",
      phoneNumber: "+678 22813",
      latitude: -17.73729,
      longitude: 168.31254,
      price: 'Varies',
      category: [""],
      isFavorite: true,
      packages: null,
    ),
  ];

  final List<Map<String, dynamic>> activities = [
    {'icon': Icons.attractions, 'label': 'Sights'},
    {'icon': Icons.tour_sharp, 'label': 'Tours'},
    {'icon': Icons.shopping_bag, 'label': 'Shops'},
    {'icon': Icons.restaurant, 'label': 'Eatery'},
    {'icon': Icons.brush, 'label': 'B&W'},
    // {'icon': Icons.child_friendly, 'label': 'Kids Space'},
    // {'icon': Icons.directions_bus, 'label': 'Transport'},
    //{'icon': Icons.place, 'label': 'Google Places'},
  ];

  final List<Map<String, dynamic>> floatMenuItems = [
    {
      'icon': Icons.directions_bus_outlined,
      'label': 'Transport',
      'screen': TransportScreen(),
    },
    {
      'icon': Icons.sim_card_download_outlined,
      'label': 'Connect',
      'screen': EsimScreen(),
    },
    {
      'icon': Icons.currency_exchange_outlined,
      'label': 'Exchange',
      'screen': ForeignCurrencyScreen(),
    },
  ];
  Weather? currentWeather;
  bool isLoadingWeather = true;
  final WeatherFactory _wf = WeatherFactory(openWeatherMapApiKey);

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future fetchWeather() async {
    try {
      Weather w = await _wf.currentWeatherByCityName('Port Vila');
      setState(() {
        currentWeather = w;
        isLoadingWeather = false;
      });
    } catch (e) {
      setState(() {
        isLoadingWeather = false;
      });
    }
  }

  IconData _mapWeatherToIcon(String? main) {
    switch (main?.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny_outlined;
      case 'clouds':
        return Icons.cloud_outlined;
      case 'rain':
      case 'drizzle':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy_outlined;
    }
  }

  Widget buildActivitiesRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 171, 194, 192),
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(activities.length, (index) {
              final activity = activities[index];
              return GestureDetector(
                onTap: () {
                  switch (activity['label']) {
                    case 'Sights':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AttractionsScreen()),
                      );
                      break;
                    case 'Tours':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ToursScreen()),
                      );
                      break;
                    case 'Shops':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShoppingScreen(),
                        ),
                      );
                      break;
                    case 'Eatery':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DiningScreen()),
                      );
                      break;
                    case 'B&W':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BeautyCareScreen(),
                        ),
                      );
                      break;
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        //padding: const EdgeInsets.all(10),
                        //decoration: BoxDecoration(
                        //shape: BoxShape.circle,
                        //color: Colors.teal.shade50,
                        //),
                        child: Icon(
                          activity['icon'],
                          size: 28,
                          color: Colors.teal.shade700,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        activity['label'],
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //final now = DateTime.now();
    //final dateString = DateFormat('EEE, MMM d').format(now);
    //final timeString = DateFormat('hh:mm a').format(now);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/port_vila_logo_trans.png',
              height: 36,
              width: 36,
            ),
            const SizedBox(width: 8),
            Text(
              'VilaCruise',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // ---- WEATHER CARD STACK WITH FLOAT MENU ----
          SizedBox(
            height: 220, // 160 for card + 60 for menu overlap
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 119, 224, 213),
                            Color.fromARGB(255, 3, 130, 115),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  // Port Vila is UTC+11
                                  final nowUtc = DateTime.now().toUtc();
                                  final vilaTime = nowUtc.add(
                                    const Duration(hours: 11),
                                  );
                                  final timeString = DateFormat(
                                    'hh:mm a',
                                  ).format(vilaTime);
                                  final dateString = DateFormat(
                                    'EEE, dd MMM',
                                  ).format(vilaTime);

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Port Vila, Vanuatu',
                                        style: GoogleFonts.homemadeApple(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 2,
                                              color: Colors.black45,
                                              offset: Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Today • $dateString',
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: 14,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 2,
                                              color: Colors.black45,
                                              offset: Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Local Time: $timeString',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 2,
                                              color: Colors.black45,
                                              offset: Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Currency: 1 AUD ≈ 80 VT',
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Column(
                              children: [
                                if (isLoadingWeather)
                                  const SizedBox(
                                    width: 40,
                                    height: 40,
                                    //child: CircularProgressIndicator(),
                                  )
                                else if (currentWeather != null) ...[
                                  Icon(
                                    _mapWeatherToIcon(
                                      currentWeather!.weatherMain,
                                    ),
                                    size: 34,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${currentWeather!.temperature?.celsius?.round() ?? '--'}°',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 2,
                                          color: Colors.black45,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        120, // or any width you want the weather box to have
                                    child: Text(
                                      currentWeather!.weatherDescription ?? '',
                                      textAlign: TextAlign.center,
                                      maxLines:
                                          2, // allow wrapping onto 2 lines
                                      overflow:
                                          TextOverflow
                                              .visible, // make sure it doesn't clip
                                      softWrap: true, // enable word wrapping
                                      style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        color: Colors.white,
                                        fontSize: 13,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 2,
                                            color: Colors.black45,
                                            offset: Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '--°',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                                  ),
                                  const Text(
                                    "No internet?",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0, // About half menu height, for overlap
                  left: 0,
                  right: 0,
                  child: FloatMenu(items: floatMenuItems),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          // Activities row
          buildActivitiesRow(),
          const SizedBox(height: 12),
          // Cruise Schedule card
          CruiseScheduleCard(
            onTap: () {
              Navigator.pushNamed(context, '/cruiseSchedule');
            },
          ),
          const SizedBox(height: 12),
          // Top 5 things
          Text(
            'Top 5 Things To Do Today',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: thingsToDo.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final tour = thingsToDo[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TourDetailScreen(tour: tour),
                      ),
                    );
                  },
                  child: Container(
                    width: size.width * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(tour.imageUrl),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.25),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tour.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              shadows: const [
                                Shadow(blurRadius: 5, color: Colors.black87),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${tour.rating} (${tour.reviews} reviews)',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tour.price,
                            style: TextStyle(
                              color: Colors.tealAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),
          // Deals & Discounts card
          Text(
            'Deals & Discounts',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                DealActionCard(
                  title: StrokedText(
                    text: 'Special Offer  Only 1,000vt',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    strokeWidth: 4,
                  ),
                  description: StrokedText(
                    text: 'Haircut, Ice cream, Smoothie.',
                    fontSize: 13,
                    strokeWidth: 2,
                  ),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(120, 117, 154, 187),
                      Color.fromARGB(120, 38, 106, 166),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  backgroundImage: 'assets/images/childrens_day.jpg',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          insetPadding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 24,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Main content: Card with gradient background
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(
                                        99,
                                        141,
                                        203,
                                        128,
                                      ), // more opaque
                                      Color.fromARGB(
                                        120,
                                        38,
                                        106,
                                        166,
                                      ), // more opaque
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/images/childrens_day.jpg',
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Pikinini bar - Childrens Day Special Offer',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Special Offer - Only 1,000vt - 21st to 25th July - incl. Haircut, Ice cream, and Smoothie.',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.shopping_bag,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        "Grab Deal",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(
                                          120,
                                          38,
                                          106,
                                          166,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pop(); // Close the dialog
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (_) => AttractionDetailScreen(
                                                  attraction: pikininibar,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // Centered, above the dialog card: X icon (white, no opacity)
                              Positioned(
                                top: -56, // negative to float above the dialog
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(99, 141, 203, 128),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 24,
                                      ), // fully opaque white
                                      onPressed:
                                          () => Navigator.of(context).pop(),
                                      splashRadius: 20,
                                      tooltip: "Close",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                DealActionCard(
                  title: StrokedText(
                    text: 'Buy 1 Get 1 Free',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    strokeWidth: 4,
                  ),
                  description: StrokedText(
                    text: 'Soda and Shakes.',
                    fontSize: 13,
                    strokeWidth: 2,
                  ),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(100, 203, 128, 158),
                      Color.fromARGB(120, 166, 38, 91),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  backgroundImage: 'assets/images/bogo.png',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          insetPadding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 24,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Main content: Card with gradient background
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(
                                        100,
                                        203,
                                        128,
                                        158,
                                      ), // more opaque
                                      Color.fromARGB(
                                        120,
                                        166,
                                        38,
                                        91,
                                      ), // more opaque
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset('assets/images/bogo.png'),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Only at Banyan Beach Bar',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '50% deals and discounts on selected drinks, soda & shakes.',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.shopping_bag,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        "Grab Deal",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(
                                          120,
                                          166,
                                          38,
                                          91,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pop(); // Close the dialog
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (_) => DiningDetailScreen(
                                                  dining: banyanbar,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // Centered, above the dialog card: X icon (white, no opacity)
                              Positioned(
                                top: -56, // negative to float above the dialog
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(100, 203, 128, 158),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 24,
                                      ), // fully opaque white
                                      onPressed:
                                          () => Navigator.of(context).pop(),
                                      splashRadius: 20,
                                      tooltip: "Close",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                DealActionCard(
                  title: StrokedText(
                    text: 'Advertise with us today',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    strokeWidth: 4,
                  ),
                  description: StrokedText(
                    text: 'Get noticed by thousands.',
                    fontSize: 13,
                    strokeWidth: 2,
                  ),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(100, 197, 203, 128),
                      Color.fromARGB(120, 166, 151, 38),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  backgroundImage:
                      'assets/images/port_vila_logo_transparent.png',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          insetPadding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 24,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Main content: Card with gradient background
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(
                                        100,
                                        197,
                                        203,
                                        128,
                                      ), // more opaque
                                      Color.fromARGB(
                                        120,
                                        166,
                                        151,
                                        38,
                                      ), // more opaque
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/images/port_vila_logo_transparent.png',
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Advertise with us today.',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Get noticed by thousands of our Port Vila\'s cruise visitors.',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        "Call now",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(
                                          120,
                                          166,
                                          151,
                                          38,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      onPressed: () async {
                                        final phoneNumber =
                                            "+678 5538355"; // Use your desired number

                                        final Uri phoneUri = Uri(
                                          scheme: 'tel',
                                          path: phoneNumber,
                                        );

                                        if (await canLaunchUrl(phoneUri)) {
                                          await launchUrl(phoneUri);
                                        } else {
                                          // Optionally show an error
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Could not launch phone dialer',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // Centered, above the dialog card: X icon (white, no opacity)
                              Positioned(
                                top: -56, // negative to float above the dialog
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(100, 197, 203, 128),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 24,
                                      ), // fully opaque white
                                      onPressed:
                                          () => Navigator.of(context).pop(),
                                      splashRadius: 20,
                                      tooltip: "Close",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Self-Guided Walking Tours card
          Text(
            'Explore at your own pace',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontSize: 16,
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 12),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Background image with a dark overlay
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/walk_tour_cover.jpg',
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.33),
                        colorBlendMode: BlendMode.darken,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              // Modern animated walking icon or badge
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.white.withOpacity(0.82),
                                child: const Icon(
                                  Icons.directions_walk,
                                  color: Colors.teal,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Self-Guided Walk',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: 18,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 5,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    '5 stops • 2 hours • Local highlights',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Call-to-action button
                Positioned(
                  bottom: 12,
                  right: 20,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SelfGuidedWalkTourScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Start Tour',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Safety & Practical Info card
          Text(
            'Safety & Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontSize: 16,
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(
                color: Color.fromARGB(255, 171, 194, 192),
                width: 1.2,
              ),
            ),
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.grey.shade50,
            child: Material(
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LocalInfoScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color.fromARGB(255, 224, 242, 241),
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.teal,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Safety and Practical Info',
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
