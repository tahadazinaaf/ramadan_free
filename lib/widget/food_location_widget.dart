import 'package:flutter/material.dart';
import 'package:ramadan_appp/data/places.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodLocationWidget extends StatelessWidget {
  final Place place;

  const FoodLocationWidget({super.key, required this.place});

  void _openMap() async {
    final url =
        "https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not open the map.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage("assets/image.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(
            place.name,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: ElevatedButton(
            onPressed: _openMap,
            child: const Text("Open in Maps"),
          ),
        ),
      ),
    );
  }
}
