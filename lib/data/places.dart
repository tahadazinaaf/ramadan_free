class Place {
  final String name;
  final double latitude;
  final double longitude;

  Place({required this.name, required this.latitude, required this.longitude});
}

List<Place> places = <Place>[
  Place(name: "مسجد النور", latitude: 36.7528, longitude: 3.0422),
  Place(name: "قاعة الإفطار المجانية", latitude: 36.7333, longitude: 3.0586),
  Place(name: "جمعية الخير", latitude: 36.7754, longitude: 3.0601),
];
