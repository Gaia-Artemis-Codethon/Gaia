import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/land.dart';
import '../../service/land_supabase.dart';
import 'landDetail.dart';

// ignore: constant_identifier_names
const MAP_KEY = '9b116f76-e8c1-4133-b90d-c7bd4b68c8c7';
const styleUrl =
    "https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png";

class MapPage extends StatefulWidget {
  final Guid userId;
  const MapPage(this.userId, {super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? myPosition;
  List<Marker> markers = [];
  @override
  void initState() {
    getCurrentLocation();
    loadMarkers();
    super.initState();
  }

  void loadMarkers() async {
    List<Land> lands = await LandSupabase().readLands();
    setState(() {
      markers = transformLandsToMarkers(lands);
    });
  }

  List<Marker> transformLandsToMarkers(List<Land> lands) {
    print(lands);
    return lands.map((land) {
      return Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(land.latitude, land.longitude),
        child: IconButton(
            icon: const Icon(
              Icons.location_on_outlined,
              color: Colors.white,
            ),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LandDetailPage(land)));
            }),
      );
    }).toList();
  }

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    Position position = await determinePosition();
    setState(() {
      myPosition = LatLng(position.latitude, position.longitude);
      print(myPosition);
    });
  }

  Widget infoMarcador() {
    return Container(
      child: Column(
        children: [
          const Text(
            'Marcador',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () async {}),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mapa'),
        backgroundColor: Colors.blueAccent,
      ),
      body: myPosition == null
          ? const CircularProgressIndicator()
          : FlutterMap(
              options: MapOptions(center: myPosition, zoom: 18),
              children: [
                TileLayer(
                  urlTemplate: styleUrl,
                  additionalOptions: const {
                    'accessToken': MAP_KEY,
                  },
                ),
                MarkerLayer(
                  markers: markers,
                ),
              ],
            ),
    );
  }
}

