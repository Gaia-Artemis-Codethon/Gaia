// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/pages/map/mapPage.dart';
import 'package:flutter_application_huerto/pages/plant/userPlants.dart';
import 'package:flutter_application_huerto/pages/toDo/toDo.dart';
import 'package:flutter_application_huerto/service/community_supabase.dart';
import 'package:flutter_application_huerto/service/supabaseService.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../components/button.dart';
import '../const/weather_constants.dart';
import '../models/current_weather_model.dart';
import '../widgets/weather_card.dart';
import 'drawing/drawing_page.dart';

class HomePage extends StatelessWidget {
  final Guid userId;

  const HomePage(this.userId, {super.key});

  Future<String> _readCommunityName() async {
    Guid guid = await SupabaseService().getUserId() as Guid;
    String name = await CommunitySupabase()
        .readCommunityNameByUserCommunityId(guid) as String;
    return name;
  }

  determinePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<String?> getCurrentLocation() async {
    var currentCity = 'Valencia';
    try {
      Position position = await determinePosition();
      LatLng myPosition = LatLng(position.latitude, position.longitude);
      double? currentLat = myPosition?.latitude;
      double? currentLong = myPosition?.longitude;
      if (currentLat != null && currentLong != null) {
        var address = await GeoCode()
            .reverseGeocoding(latitude: currentLat, longitude: currentLong);
        if (address == null) {
          return "Valencia";
        } else {
          return address.city;
        }
      }
    } catch (e) {
      debugPrint("Error getting city: $e");
    }
    return currentCity;
  }

  Future<CurrentWeatherModel?>? _getCurrentWeather() async {
    String? city = await getCurrentLocation();
    if (city == null) {
      city = "Valencia";
    }
    if (city == "Valencia") {
      city = city + ",ES";
    } //ToDo: Do not hardcode in case of conflict

    final Uri uri = Uri.parse(
        '${Constants.currentWeatherApiUrl}?${Constants.key}=${Constants.apiKey}&${Constants.q}=${city}&${Constants.lang}=es');
    final Uri uri2 = Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=6164cf989b99407a9bb45846242604&q=Valencia&lang=es');
    CurrentWeatherModel currentWeather;
    try {
      final response = await http.get(uri);
      var data = json.decode(response.body.toString());
      if (response.statusCode == 200) {
        currentWeather = CurrentWeatherModel.fromJson(data);
        return currentWeather;
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage("images/verdep2.jpg"), // Agregar imagen de fondo
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: const CircleAvatar(
                    radius: 27,
                    backgroundColor: Color.fromARGB(108, 155, 79, 1),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('images/granjero.png'),
                    ),
                  ),
                ),
                FutureBuilder<String>(
                  future: _readCommunityName(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: const Text(
                              'MI COMUNIDAD:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21),
                            ),
                          ),
                          Text(
                            snapshot.data ?? 'Default Community Name',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage('images/verdep2.jpg'), // Agregar imagen de fondo
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    FutureBuilder<CurrentWeatherModel?>(
                      future: _getCurrentWeather(),
                      builder: (BuildContext context,
                          AsyncSnapshot<CurrentWeatherModel?> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: double.infinity,
                            height: 250,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF7CB9FF), // Start color
                                  Color(0xFF5162FF), // End color
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white))
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                              child:
                                  Text('An error occurred: ${snapshot.error}'));
                        } else {
                          final weatherData = snapshot.data;
                          if (weatherData == null) {
                            return Center(
                                child: Text('No weather data available'));
                          } else {
                            return WeatherCard(weather: weatherData);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Mi parcela",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ToDo(userId),
                          ),
                        );
                      },
                      child: Container(
                        height: 180.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: OurColors().sectionBackground,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Lista de tareas",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: SvgPicture.asset("images/todo.svg",
                                  width: 100, height: 100),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ToDo(userId),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserPlants(userId),
                          ),
                        );
                      },
                      child: Container(
                        height: 180.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: OurColors().sectionBackground,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Cultivos",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: SvgPicture.asset("images/planta.svg",
                                  width: 100, height: 100),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserPlants(userId),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapPage(userId)),
                        );
                      },
                      child: Container(
                        height: 180.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: OurColors().sectionBackground,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Mapa",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: SvgPicture.asset("images/mapa.svg",
                                  width: 100, height: 100),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapPage(userId)),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
