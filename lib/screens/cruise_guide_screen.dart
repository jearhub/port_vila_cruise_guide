//import 'package:VilaCruise/screens/all_locations_map_screen.dart';
import 'package:VilaCruise/screens/all_locations_map_screen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'places_screen.dart';
import 'map_screen.dart';
import 'tours_screen.dart';
import 'package:weather/weather.dart';
import '../secret.dart';
import 'local_info_screen.dart';
import 'self_guided_walk_tour_screen.dart';
import 'dining_screen.dart';
import 'shopping_screen.dart';
import 'beauty_care_screen.dart';
//import 'kids_space_screen.dart';
import 'transport_screen.dart';
import 'attractions_screen.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'foreign_currency_screen.dart';
import 'profile_screen.dart';
import 'thingstodo_detail_screen.dart';
import '../widgets/cruise_schedule_card.dart';
import 'esim_screen.dart';
import '../widgets/business_card.dart';
import '../models/deal.dart';
import '../widgets/deals_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/thingstodo_fire_card.dart';
import 'category_attractions_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      const CustomSearchBar(),
      const AllLocationsMapScreen(),
      const LocalInfoScreen(),
      ProfileScreen(
        onTabSwitch: (tabIndex) {
          setState(() {
            _currentIndex = tabIndex;
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
        return true; // Allows app minimization when already on home
      },
      child: Scaffold(
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
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outlined),
              label: 'Info',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: 'Account',
            ),
          ],
        ),
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
                        borderRadius: BorderRadius.circular(22),
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
                                Image.asset(
                                  item['iconPath'],
                                  height: 42,
                                  width: 42,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['label'],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
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
  Future<void> saveDealToMyDeals(Deal deal) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('myDeals')
        .doc(deal.id)
        .set(deal.toMap());
  }

  void _showDealDialog(BuildContext parentContext, Deal deal) {
    showDialog(
      context: parentContext,
      builder:
          (dialogContext) => Stack(
            children: [
              Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      deal.imageUrl.startsWith('http')
                          ? Image.network(deal.imageUrl)
                          : Image.asset(deal.imageUrl),
                      const SizedBox(height: 10),
                      Text(
                        deal.popupTitle,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        deal.popupDescription,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(),
                      ),
                      const SizedBox(height: 22),
                      ElevatedButton.icon(
                        icon: const Icon(
                          Icons.shopping_bag,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Grab Deal",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade700,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();
                          await saveDealToMyDeals(deal);
                          showDialog(
                            context: parentContext,
                            builder:
                                (confirmationContext) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Text(
                                    "Congratulations!",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Text(
                                    "This deal is now saved for you.\nShow this confirmation at the venue to redeem. \nAlso available in 'My Deals'.",
                                    style: GoogleFonts.poppins(),
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal.shade700,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed:
                                          () =>
                                              Navigator.of(
                                                confirmationContext,
                                              ).pop(),
                                      child: Text(
                                        "Show to Vendor",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 0,
                left: 0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => Navigator.of(dialogContext).pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  final List<Map<String, dynamic>> activities = [
    {'icon': Icons.attractions, 'label': 'Sights'},
    {'icon': Icons.tour_sharp, 'label': 'Tours'},
    {'icon': Icons.shopping_bag, 'label': 'Shops'},
    {'icon': Icons.restaurant, 'label': 'Diners'},
    {'icon': Icons.brush, 'label': 'B&W'},
    // {'icon': Icons.child_friendly, 'label': 'Kids Space'},
    {'icon': Icons.place, 'label': 'Places'},
  ];

  final List<Map<String, dynamic>> floatMenuItems = [
    {
      'iconPath': 'assets/icons/bus.png',
      'label': 'Transport',
      'screen': TransportScreen(),
    },
    {
      'iconPath': 'assets/icons/mobile.png',
      'label': 'Internet',
      'screen': EsimScreen(),
    },
    {
      'iconPath': 'assets/icons/currency.png',
      'label': 'Exchange',
      'screen': ForeignCurrencyScreen(),
    },
  ];

  // Activity Categories to show as sliding cards
  final List<Map<String, String>> activityCategories = [
    {"category": "Beaches", "imageUrl": "assets/images/beach_relaxation.jpg"},
    {"category": "Waterfalls", "imageUrl": "assets/images/waterfallhike.jpg"},
    {"category": "Sports", "imageUrl": "assets/images/buggy_adventure.jpg"},
    {"category": "Markets", "imageUrl": "assets/images/market.jpg"},
    {"category": "Events", "imageUrl": "assets/images/live_event.jpg"},
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

  Future<void> _onRefresh() async {
    if (await InternetConnectionChecker().hasConnection) {
      setState(() {
        isLoadingWeather = true;
      });
      await fetchWeather();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No internet connection')));
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
                    case 'Diners':
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
                    case 'Places':
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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                                                GoogleFonts.poppins()
                                                    .fontFamily,
                                            fontSize: 13,
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
                                          'Local Time: $timeString',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily:
                                                GoogleFonts.poppins()
                                                    .fontFamily,
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
                                        //const Divider(),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Currency: 1 AUD ≈ 80 VT',
                                          style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.poppins()
                                                    .fontFamily,
                                            fontSize: 12,
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
                                      size: 32,
                                      color: Colors.orange,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 2,
                                          color: Colors.black45,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${currentWeather!.temperature?.celsius?.round() ?? '--'}°',
                                      style: const TextStyle(
                                        fontSize: 22,
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
                                        currentWeather!.weatherDescription ??
                                            '',
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
                                          fontSize: 12,
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
                                        fontSize: 22,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                      ),
                                    ),
                                    const Text(
                                      "No internet?",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
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
            const SizedBox(height: 4),
            SizedBox(
              width: 160,
              height: 225,
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('thingstodo')
                        .limit(5)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final activities =
                      snapshot.data!.docs
                          .map((doc) => doc.data() as Map<String, dynamic>)
                          .toList();
                  if (activities.isEmpty) {
                    return Center(child: Text('No activities found'));
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: activities.length,
                    separatorBuilder: (context, index) => SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final thing = activities[index];
                      return ThingstodoFireCard(
                        thing: thing,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => ThingstodoDetailScreen(thing: thing),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Deals & Discounts",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('deals').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const Center(child: CircularProgressIndicator());
                  final deals =
                      snapshot.data!.docs
                          .map(
                            (doc) => Deal.fromFirestore(
                              doc.data() as Map<String, dynamic>,
                              doc.id,
                            ),
                          )
                          .toList();

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: deals.length,
                    itemBuilder: (context, index) {
                      final deal = deals[index];
                      return SizedBox(
                        height: 140,
                        child: DealsCard(
                          title: deal.title,
                          description: deal.description,
                          imageUrl: deal.imageUrl,
                          onTap:
                              () => _showDealDialog(
                                context,
                                deal,
                              ), // always use outer context
                        ),
                      );
                    },
                  );
                },
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
                                  backgroundColor: Colors.white.withOpacity(
                                    0.82,
                                  ),
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
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SelfGuidedWalkTourScreen(),
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
            // Horizontal sliding cards for category activities
            Text(
              'Pick your own adventure',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: activityCategories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final cat = activityCategories[index];
                  return SizedBox(
                    width: 140,
                    child: BusinessCard(
                      category: cat['category'] ?? '',
                      imageUrl: cat['imageUrl'] ?? '',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CategoryAttractionsScreen(
                                  category: cat['category']!,
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),
            // Safety & Practical Info card
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
                      MaterialPageRoute(
                        builder: (_) => const LocalInfoScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/technology.png',
                          height: 36,
                          width: 36,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Practical Information',
                              style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4), // optional spacing
                            Text(
                              'Health, safety, and local tips',
                              style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
