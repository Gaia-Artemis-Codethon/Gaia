import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import '../../models/land.dart'; // Reemplaza con la definición de tu modelo Land
import '../../service/land_supabase.dart';
import '../home_page.dart';
import '../plant/userPlants.dart';
import '../toDo/toDo.dart';
import '../../shared/bottom_navigation_bar.dart';

class MapPage extends StatefulWidget {
  final Guid userId;
  const MapPage(this.userId, {Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController mapController = MapController();
  bool isLoading = true;
  List<Land> lands = [];
  List<Marker> markers = [];
  int indexLand = -1;
  int _currentIndex = 3;
  LatLng? currentPosition;
  bool hasLocationPermission = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _requestPermissionAndLoadData(); // Cambiado a nuevo método que solicita permiso
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _requestPermissionAndLoadData() async {
    final permissionStatus = await Geolocator.requestPermission();
    setState(() {
      hasLocationPermission = permissionStatus == LocationPermission.always ||
          permissionStatus == LocationPermission.whileInUse;
    });
    if (permissionStatus == LocationPermission.deniedForever) {
      setState(() {
        currentPosition =
            LatLng(39.4699, -0.3763); // Latitud y longitud de Valencia
      });
    } else if (permissionStatus == LocationPermission.denied) {
      // Si el usuario negó los permisos, puedes mostrar un diálogo o mensaje para informar y solicitar permisos nuevamente.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permiso de ubicación necesario'),
            content: Text(
                'La aplicación necesita permiso de ubicación para funcionar correctamente. Por favor, habilite los permisos en la configuración de la aplicación.'),
            actions: <Widget>[
              TextButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _requestPermissionAndLoadData(); // Solicita permisos nuevamente
                },
              ),
            ],
          );
        },
      );
    } else {
      // Si se otorgan permisos, obtén la ubicación actual y carga los datos
      await _getCurrentLocation();
    }
    await _loadLands();
  }

  Future<void> _loadLands() async {
    lands = await LandSupabase().readLands();
    setState(() {
      lands.sort(
          (a, b) => _calculateDistance(a).compareTo(_calculateDistance(b)));
      markers = _transformLandsToMarkers(lands);
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      debugPrint("Error getting location: $e");
      // Si ocurre un error al obtener la ubicación, muestra una ubicación inicial en Valencia
      setState(() {
        currentPosition =
            LatLng(39.4699, -0.3763); // Latitud y longitud de Valencia
      });
    }
  }

  double _calculateDistance(Land land) {
    if (currentPosition == null) return double.infinity;
    final landPosition = LatLng(land.latitude, land.longitude);
    final distance = Distance();
    return distance(currentPosition!, landPosition);
  }

  List<Marker> _transformLandsToMarkers(List<Land> lands) {
    return lands.map((land) {
      return Marker(
        width: 50.0,
        height: 50.0,
        point: LatLng(land.latitude, land.longitude),
        child: IconButton(
          icon: const Icon(
            Icons.location_on,
            color: Color.fromARGB(255, 19, 67, 29),
            size: 30.0,
          ),
          onPressed: () async {
            mapController.move(LatLng(land.latitude, land.longitude), 18);
            double destinationLatitude = land.latitude;
            double destinationLongitude = land.longitude;
            String url =
                'https://www.google.com/maps/dir/?api=1&destination=$destinationLatitude,$destinationLongitude';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
      );
    }).toList();
  }

  Widget _buildMap() {
    return FutureBuilder<Style>(
      future: _readMapStyle(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return _map(snapshot.data!);
        }
      },
    );
  }

  Future<Style> _readMapStyle() {
    return StyleReader(
      uri:
          'https://api.maptiler.com/maps/streets/style.json?key=HKZgWQ6cymRQiWZP0MRL',
      apiKey: 'HKZgWQ6cymRQiWZP0MRL',
    ).read();
  }

  Widget _map(Style style) {
    return Column(
      children: [
        Expanded(
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: currentPosition ??
                  LatLng(39.4699, -0.3763), // Centro de Valencia
              zoom: 18,
              minZoom: 10, // Zoom mínimo
              maxZoom: 22, // Zoom máximo
            ),
            children: [
              VectorTileLayer(
                tileProviders: style.providers,
                theme: style.theme,
                sprites: style.sprites,
                maximumZoom: 22,
                layerMode: VectorTileLayerMode.vector,
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
              final distance = _calculateDistance(land).toStringAsFixed(2);
              return ListTile(
                title: Text(land.location),
                subtitle:
                    Text('Size: ${land.size}, Distance: $distance meters'),
                onTap: () {
                  mapController.move(
                    LatLng(land.latitude, land.longitude),
                    18,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading ? Center(child: CircularProgressIndicator()) : _buildMap(),
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
