import 'package:flutter/material.dart';
import 'places_screen.dart';
import 'tours_screen.dart';
import 'package:weather/weather.dart';
import '../models/tour.dart';
import 'tour_detail_screen.dart';
import 'custom_search_bar.dart' as custom_search_bar;
import '../widgets/deal_action_card.dart';
import '../secret.dart';
import 'local_info_screen.dart';
import 'self_guided_walk_tour_screen.dart';
import 'dining_screen.dart';
import 'shopping_screen.dart';
import 'beauty_care_screen.dart';
import 'kids_space_screen.dart';
import 'transport_screen.dart';
import '../widgets/stroked_text.dart';
import 'attractions_screen.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'foreign_currency_screen.dart';

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
      const CruiseGuideHomeContent(), // Home tab with search bar
      const TransportScreen(),
      ForeignCurrencyScreen(),
      const LocalInfoScreen(),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Transport',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Currency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Info',
          ),
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

class _CruiseGuideHomeContentState extends State<CruiseGuideHomeContent> {
  final List<Tour> thingsToDo = const [
    Tour(
      name: "Nguna Island Tours",
      description:
          "An offshore Island of Efate with an extinct volcano crater. Home to the national annual event called the 'Taleva Run'..",
      imageUrl: "assets/images/taleva_run.jpg",
      openingHours: "8:00 AM - 4:00 PM",
      entryFee: "5000 VUV",
      duration: "3 hours",
      skipLine: false,
      pickupAvailable: true,
      rating: 4.7,
      reviews: 85,
      price: "\VT 5,000",
      category: [""],
    ),
    Tour(
      name: 'Cultural Village Tour',
      description: 'Experience the rich culture of Port Vila.',
      imageUrl: 'assets/images/cultural_village.jpg',
      openingHours: '9:00 AM - 4:00 PM',
      entryFee: 'Included',
      duration: '4 hours',
      skipLine: false,
      pickupAvailable: true,
      rating: 4.5,
      reviews: 98,
      price: '\VT 5,000',
      category: [""],
    ),
    Tour(
      name: 'Lagoon Cruise',
      description: 'Relax on a scenic lagoon cruise.',
      imageUrl: 'assets/images/lagoon_cruise.jpg',
      openingHours: '9:00 AM - 5:00 PM',
      entryFee: 'Included',
      duration: '3 hours',
      skipLine: true,
      pickupAvailable: true,
      rating: 4.7,
      reviews: 120,
      price: '\VT 7,500',
      category: [""],
    ),
    Tour(
      name: 'Waterfall Hike',
      description: 'Hike to stunning waterfalls surrounded by nature.',
      imageUrl: 'assets/images/waterfall_hike.jpg',
      openingHours: '8:00 AM - 3:00 PM',
      entryFee: 'Free',
      duration: '5 hours',
      skipLine: false,
      pickupAvailable: false,
      rating: 4.8,
      reviews: 75,
      price: 'Free',
      category: [""],
    ),
    Tour(
      name: 'Market Shopping',
      description: 'Shop for local crafts and souvenirs at the market.',
      imageUrl: 'assets/images/market_shopping.jpg',
      openingHours: '7:00 AM - 6:00 PM',
      entryFee: 'Free',
      duration: '2 hours',
      skipLine: false,
      pickupAvailable: false,
      rating: 4.3,
      reviews: 60,
      price: 'Varies',
      category: [""],
    ),
  ];

  final List<Map<String, dynamic>> activities = [
    {'icon': Icons.attractions, 'label': 'Attractions'},
    {'icon': Icons.tour_sharp, 'label': 'Tours'},
    {'icon': Icons.restaurant, 'label': 'Dining'},
    {'icon': Icons.shopping_bag, 'label': 'Shopping'},
    {'icon': Icons.brush, 'label': 'Beauty Care'},
    {'icon': Icons.child_friendly, 'label': 'Kids Space'},
    {'icon': Icons.directions_bus, 'label': 'Transport'},
    {'icon': Icons.place, 'label': 'Google Places'},
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
          color: Colors.white.withOpacity(0.85),
          border: Border.all(
            color: const Color.fromARGB(255, 171, 194, 192),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(activities.length, (index) {
              final activity = activities[index];
              return GestureDetector(
                onTap: () {
                  switch (activity['label']) {
                    case 'Attractions':
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
                    case 'Dining':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DiningScreen()),
                      );
                      break;
                    case 'Shopping':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShoppingScreen(),
                        ),
                      );
                      break;
                    case 'Beauty Care':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BeautyCareScreen(),
                        ),
                      );
                      break;
                    case "Kids Space":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KidsSpaceScreen(),
                        ),
                      );
                      break;
                    case 'Transport':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TransportScreen(),
                        ),
                      );
                      break;
                    case 'Google Places':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PlacesScreen()),
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
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.teal.shade50,
                        ),
                        child: Icon(
                          activity['icon'],
                          size: 24,
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

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.teal,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/port_vila_logo_trans.png',
              height: 36,
              width: 36,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: SizedBox(
                height: 40,
                child: custom_search_bar.CustomSearchBar(
                  onChanged: (query) {
                    // filter logic here if needed
                    print("Searching: $query");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // --- Live Weather Ship Info Card ---
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            //elevation: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Container(
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
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                          spreadRadius: 2,
                        ),
                      ],
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(20),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    const SizedBox(height: 10),
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
                                  child: CircularProgressIndicator(),
                                )
                              else if (currentWeather != null) ...[
                                Icon(
                                  _mapWeatherToIcon(
                                    currentWeather!.weatherMain,
                                  ),
                                  size: 40,
                                  color: Colors.orange,
                                ),
                                const SizedBox(height: 4),
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
                                    maxLines: 2, // allow wrapping onto 2 lines
                                    overflow:
                                        TextOverflow
                                            .visible, // make sure it doesn't clip
                                    softWrap: true, // enable word wrapping
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
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
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  'Weather offline',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Activities row
          Text(
            'Explore Onshore Activities',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          buildActivitiesRow(),

          const SizedBox(height: 24),
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
            height: 160,
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
            height: 155,
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
                    text: 'Haircut, Ice cream, Smoothie',
                    fontSize: 13,
                    strokeWidth: 2,
                  ),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(99, 141, 203, 128),
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
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(99, 141, 203, 128),
                                  Color.fromARGB(120, 38, 106, 166),
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
                                ), // deal image
                                SizedBox(height: 10),
                                Text(
                                  'Pikinini bar - Childrens Day Special Offer',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Special Offer - Only 1,000vt - 21st to 25th July - incl. Haircut, Ice cream, Smoothie',
                                ),
                                SizedBox(height: 16),
                                TextButton(
                                  child: Text("Close"),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
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
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(100, 203, 128, 158),
                                  Color.fromARGB(120, 166, 38, 91),
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
                                  'assets/images/bogo.png',
                                ), // deal image
                                SizedBox(height: 10),
                                Text(
                                  'Buy 1 Get 1 Free',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'All 20% deals and discounts at Paul\'s Cafe & catering services',
                                ),
                                SizedBox(height: 16),
                                TextButton(
                                  child: Text("Close"),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                DealActionCard(
                  title: StrokedText(
                    text: 'City Center Live',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    strokeWidth: 4,
                  ),
                  description: StrokedText(
                    text: 'Local Entertainment Free.',
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
                  backgroundImage: 'assets/images/live_event.jpg',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(100, 203, 128, 158),
                                  Color.fromARGB(120, 166, 38, 91),
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
                                  'assets/images/live_event.jpg',
                                ), // deal image
                                SizedBox(height: 10),
                                Text(
                                  'Free Live Entertainment at Feiaua',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Join and Experience the local cultural dances and string band music.',
                                ),
                                SizedBox(height: 16),
                                TextButton(
                                  child: Text("Close"),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
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
                width: 1.5,
              ),
            ),
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.grey.shade50,
            child: Material(
              color: Colors.transparent,
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
                          color: Colors.black87,
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
