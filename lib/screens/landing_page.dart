import 'package:flutter/material.dart';
import 'package:ramadan_appp/data/places.dart';
import 'package:ramadan_appp/screens/AddPlaceScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Position? _currentPosition;
  List<Place> sortedPlaces = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  // Get user's current location
  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    // Fetch location and sort places by proximity
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      sortedPlaces = List.from(places);
      sortedPlaces.sort((a, b) {
        double distanceA = Geolocator.distanceBetween(
            position.latitude, position.longitude, a.latitude, a.longitude);
        double distanceB = Geolocator.distanceBetween(
            position.latitude, position.longitude, b.latitude, b.longitude);
        return distanceA.compareTo(distanceB);
      });
    });
  }

  // Open place in Google Maps
  void _openMap(double lat, double lng) async {
    final Uri url =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "تعذر فتح الخريطة";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/first_screen.jpg",
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: FutureBuilder(
                future: _getUserLocation(),
                builder: (context, snapshot) {
                  if (_currentPosition == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 200),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final place = sortedPlaces[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      "assets/image.jpg",
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6938D3)
                                          .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  Positioned(
                                    top: 50,
                                    right: 20,
                                    child: Text(
                                      place.name,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 15,
                                    right: 128,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF6938D3),
                                      ),
                                      onPressed: () => _openMap(
                                          place.latitude, place.longitude),
                                      child: const Text(
                                        "افتح الخريطة",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: sortedPlaces.length,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              bottom: 10,
              left: 20,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6938D3),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPlaceScreen()),
                  );
                },
                child: const Text(
                  "قم بإضافة مكان إفطار السبيل",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
