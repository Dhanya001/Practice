import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final TextEditingController _searchController = TextEditingController();

  List<String> _allLocations = [
    "Mumbai",
    "Delhi",
    "Bangalore",
    "Chennai",
    "Kolkata",
    "Pune",
    "Hyderabad",
    "Ahmedabad",
    "Jaipur",
    "Lucknow",
  ];

  List<String> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _filteredLocations = _allLocations; // Initially show all locations
    _searchController.addListener(_filterLocations);
  }

  void _filterLocations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLocations = _allLocations
          .where((location) => location.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your location"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for a location",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredLocations.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CurrentUserLocation(
                          cityName: _filteredLocations[index],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _filteredLocations[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class CurrentUserLocation extends StatefulWidget {
  final String cityName;

  const CurrentUserLocation({required this.cityName, super.key});

  @override
  State<CurrentUserLocation> createState() => _CurrentUserLocationState();
}

class _CurrentUserLocationState extends State<CurrentUserLocation> {
  late GoogleMapController googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(19.2530317, 73.1366), zoom: 14);

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _setCityMarker(widget.cityName);
  }

  Future<void> _setCityMarker(String cityName) async {
    // Simulating lat/lng for simplicity
    final Map<String, LatLng> cityCoordinates = {
      "Mumbai": LatLng(19.0760, 72.8777),
      "Delhi": LatLng(28.7041, 77.1025),
      "Bangalore": LatLng(12.9716, 77.5946),
      "Chennai": LatLng(13.0827, 80.2707),
      "Kolkata": LatLng(22.5726, 88.3639),
      "Pune": LatLng(18.5204, 73.8567),
      "Hyderabad": LatLng(17.3850, 78.4867),
      "Ahmedabad": LatLng(23.0225, 72.5714),
      "Jaipur": LatLng(26.9124, 75.7873),
      "Lucknow": LatLng(26.8467, 80.9462),
    };

    final LatLng? latLng = cityCoordinates[cityName];
    if (latLng != null) {
      setState(() {
        markers.add(Marker(
          markerId: MarkerId(cityName),
          position: latLng,
          infoWindow: InfoWindow(title: cityName),
        ));
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 12),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cityName),
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
    );
  }
}


