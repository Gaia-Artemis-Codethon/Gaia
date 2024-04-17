import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/land.dart';
import '../../service/land_supabase.dart';
import 'landDetail.dart';

const MAP_KEY = '9b116f76-e8c1-4133-b90d-c7bd4b68c8c7';
const styleUrl = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";

class MapPage extends StatefulWidget {
  final Guid userId;
  const MapPage(this.userId, {super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Flag to track permission status and UI loading state
  bool hasLocationPermission = false;
  bool isLoading = true;

  LatLng? myPosition;
  List<Land> lands = [];
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
  LocationPermission permission = await Geolocator.requestPermission();

  setState(() {
    hasLocationPermission = permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  });

  if (permission == LocationPermission.denied) {
    // Handle permission denied case (e.g., show a message)
    setState(() {
      isLoading = false;
      loadLands();
    });
    print("Location permission denied");
  } else if (permission == LocationPermission.deniedForever) {
    setState(() {
      isLoading = false;
      loadLands();
    });
    // Handle permanently denied case (e.g., show a message)
    print("Location permission permanently denied");
  } else {
    // Permission granted, proceed with location access
    await getCurrentLocation().then((_) => setState(() {
      isLoading = false;
      loadLands();
    }));
  }
}

  Future<Position> determinePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await determinePosition();
      setState(() {
        myPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  void loadLands() async {
    lands = await LandSupabase().readLands();
    setState(() {
      // Ordenar las lands por proximidad
      lands.sort(
          (a, b) => _calculateDistance(a).compareTo(_calculateDistance(b)));
      // Transformar las lands en marcadores
      markers = transformLandsToMarkers(lands);
      if(hasLocationPermission){
        markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: myPosition!,
          child: const Icon(
            Icons.location_on,
            color: Colors.blue,
            size: 50.0,
          ),
        ),
      );
      }
    });
  }

  double _calculateDistance(Land land) {
    if (myPosition == null) return double.infinity;
    final landPosition = LatLng(land.latitude, land.longitude);
    var distance = const Distance();
    return distance(myPosition!, landPosition);
  }

  List<Marker> transformLandsToMarkers(List<Land> lands) {
    return lands.map((land) {
      return Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(land.latitude, land.longitude),
        child: IconButton(
          icon: const Icon(
            Icons.location_on,
            color: Colors.black,
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LandDetailPage(land),
              ),
            );
          },
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator()); // Show loading indicator
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mapa'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StatefulBuilder(
        // Wrap the body with StatefulBuilder
        builder: (context, setState) => Column(
          children: [
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  center: hasLocationPermission
                      ? myPosition
                      : const LatLng(39.4702, -0.3898), // Center of Valencia
                  zoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate: styleUrl,
                    additionalOptions: const {
                      'accessToken': MAP_KEY,
                    },
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: lands.length,
                itemBuilder: (context, index) {
                  final land = lands[index];
                  return ListTile(
                    title: Text(land.location),
                    subtitle: Text(
                      hasLocationPermission
                          ? 'Tamaño: ${land.size}, Proximidad: ${_calculateDistance(land).toStringAsFixed(2)} metros'
                          : 'Tamaño: ${land.size}, Proximidad: No disponible',
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LandDetailPage(land),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
