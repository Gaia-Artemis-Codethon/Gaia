import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/land.dart';
import '../../service/land_supabase.dart';
import '../home_page.dart';
import '../plant/userPlants.dart';
import '../toDo/toDo.dart';
import '../../shared/bottom_navigation_bar.dart';

const MAP_KEY = '9b116f76-e8c1-4133-b90d-c7bd4b68c8c7';
const styleUrl = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";

class MapPage extends StatefulWidget {
  final Guid userId;
  const MapPage(this.userId, {Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController mapController = MapController();
  bool hasLocationPermission = false;
  bool isLoading = true;

  LatLng? myPosition;
  List<Land> lands = [];
  List<Marker> markers = [];

  int _currentIndex = 3;
  int indexLand = -1;

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
      print("Location permission permanently denied");
    } else {
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
      lands.sort(
          (a, b) => _calculateDistance(a).compareTo(_calculateDistance(b)));
      markers = transformLandsToMarkers(lands);
      if (hasLocationPermission) {
        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: myPosition!,
            child: IconButton(
              icon: const Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 30.0,
              ),
              onPressed: () {
                mapController.move(myPosition!, 18);
              },
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
        width: 50.0,
        height: 50.0,
        point: LatLng(land.latitude, land.longitude),
        child: IconButton(
          icon: const Icon(
            Icons.location_on,
            color: Colors.black,
            size: 30.0,
          ),
          onPressed: () {
            mapController.move(LatLng(land.latitude, land.longitude), 18);
          },
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      backgroundColor: OurColors().backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: OurColors().backgroundColor,
        elevation: 0,
        title: Center(
          child: Text('Map'),
        ),
      ),
      body: StatefulBuilder(
        builder: (context, setState) => Column(
          children: [
            Expanded(
              flex: 3,
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: indexLand != -1
                      ? LatLng(
                          lands[indexLand].latitude, lands[indexLand].longitude)
                      : (hasLocationPermission
                          ? myPosition!
                          : const LatLng(39.4702, -0.3898)),
                  zoom: 18,
                  keepAlive: false,
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
              flex: 1,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                      itemCount: lands.length,
                      itemBuilder: (context, index) {
                        final land = lands[index];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListTile(
                            title: Text(land.location),
                            subtitle: Text(
                              hasLocationPermission
                                  ? 'Size: ${land.size}, Proximity: ${_calculateDistance(land).toStringAsFixed(2)} meters'
                                  : 'Size: ${land.size}, Proximity: Not available',
                            ),
                            selected: index == indexLand,
                            onTap: () {
                              setState(() {
                                indexLand = index;
                                mapController.move(
                                    LatLng(lands[index].latitude,
                                        lands[index].longitude),
                                    18);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() {
              _currentIndex = index;
            });
            if (_currentIndex == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(widget.userId),
                ),
              );
            } else if (_currentIndex == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ToDo(widget.userId),
                ),
              );
            } else if (_currentIndex == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserPlants(widget.userId),
                ),
              );
            }
          }
        },
        currentIndex: _currentIndex,
      ),
    );
  }
}
