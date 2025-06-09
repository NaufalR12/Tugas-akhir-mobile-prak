import 'dart:async';
import 'dart:convert';
// Untuk Clipboard
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  LatLng? _mylocation;
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounce;

  double _calculateDistance(LatLng start, LatLng end) {
    final Distance distance = Distance();
    return distance(start, end);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanently denied");
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _loadNearbyExpeditions() async {
    if (_mylocation == null) return;
    final url =
        'https://nominatim.openstreetmap.org/search?format=json&limit=20&countrycodes=ID&q=ekspedisi&accept-language=id';
    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'PaketKu/1.0 (your@email.com)'},
    );
    final data = json.decode(response.body);
    if (data is List) {
      List<dynamic> sortedResults = data.map((item) {
        final lat = double.parse(item['lat']);
        final lon = double.parse(item['lon']);
        final distance = _calculateDistance(_mylocation!, LatLng(lat, lon));
        return {...item, 'distance': distance};
      }).toList();
      sortedResults.sort((a, b) => a['distance'].compareTo(b['distance']));
      setState(() {
        _markers = sortedResults.map((item) {
          final lat = double.parse(item['lat']);
          final lon = double.parse(item['lon']);
          final name = item['display_name'] ?? 'Ekspedisi';
          return Marker(
            point: LatLng(lat, lon),
            width: 80,
            height: 80,
            child: Column(
              children: [
                Icon(Icons.local_shipping, color: Colors.blue, size: 36),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    name.split(',')[0],
                    style: TextStyle(fontSize: 10, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      });
    }
  }

  void _showCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      setState(() {
        _mylocation = currentLatLng;
      });
      _mapController.move(currentLatLng, 15.0);
      await _loadNearbyExpeditions();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty || _mylocation == null) {
      setState(() => _searchResults = []);
      return;
    }
    final url =
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=10&countrycodes=ID&accept-language=id';
    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'PaketKu/1.0 (your@email.com)'},
    );
    final data = json.decode(response.body);
    if (data is List && data.isNotEmpty) {
      List<dynamic> sorted = data.map((item) {
        final lat = double.tryParse(item['lat']) ?? 0.0;
        final lon = double.tryParse(item['lon']) ?? 0.0;
        final distance = _calculateDistance(_mylocation!, LatLng(lat, lon));
        return {...item, 'distance': distance};
      }).toList();
      sorted.sort((a, b) => a['distance'].compareTo(b['distance']));
      setState(() => _searchResults = sorted);
    } else {
      setState(() => _searchResults = []);
    }
  }

  @override
  void initState() {
    super.initState();
    _showCurrentLocation();
    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _searchPlaces(_searchController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ekspedisi Terdekat'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(-7.7769, 110.3572),
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(markers: _markers),
              if (_mylocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _mylocation!,
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Column(
              children: [
                SizedBox(
                  height: 55,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Cari lokasi...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _isSearching
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _isSearching = false;
                                  _searchResults = [];
                                });
                              },
                              icon: Icon(Icons.clear),
                            )
                          : null,
                    ),
                    onTap: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
                ),
                if (_isSearching && _searchResults.isNotEmpty)
                  Container(
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (ctx, index) {
                        final place = _searchResults[index];
                        final distance = place['distance'] as double;
                        return ListTile(
                          title: Text(place['display_name']),
                          subtitle: Text(
                              'Jarak: ${(distance / 1000).toStringAsFixed(2)} km'),
                          onTap: () {
                            final lat = double.parse(place['lat']);
                            final lon = double.parse(place['lon']);
                            _mapController.move(LatLng(lat, lon), 15.0);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo,
              onPressed: _showCurrentLocation,
              child: Icon(Icons.location_searching_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
