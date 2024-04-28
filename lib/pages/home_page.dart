import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/data/models/current_weather.dart';
import 'package:flutter_application_huerto/pages/map/mapPage.dart';
import 'package:flutter_application_huerto/pages/toDo/toDo.dart';
import 'package:flutter_application_huerto/service/community_supabase.dart';
import 'package:flutter_application_huerto/service/supabaseService.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../components/button.dart';
import '../const/weather_constants.dart';
import '../models/current_weather_model.dart';
import '../widgets/weather_card.dart';

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

 Future<String> getCurrentLocation() async {
   var currentCity = 'Valencia';
   try {
     Position position = await determinePosition();
     LatLng myPosition = LatLng(position.latitude, position.longitude);
     double? currentLat = myPosition?.latitude;
     double? currentLong = myPosition?.longitude;
     if(currentLat != null && currentLong != null){
       var address = await GeoCode().reverseGeocoding(latitude: currentLat, longitude:currentLong);
       print(address.city);
       return 'Valencia';
     }
   } catch (e) {
     debugPrint("Error getting city: $e");
   }
   return currentCity;
 }

 Future<CurrentWeatherModel?>? _getCurrentWeather() async {
   String city = await getCurrentLocation();
   if(city == "Valencia"){city = city+",ES";} //ToDo: Do not hardcode in case of conflict

   final Uri uri = Uri.parse(
       '${Constants.currentWeatherApiUrl}?${Constants.key}=${Constants.apiKey}&${Constants.q}=${city}&${Constants.lang}=es');
   final Uri uri2 = Uri.parse(
       'http://api.weatherapi.com/v1/current.json?key=6164cf989b99407a9bb45846242604&q=Valencia&lang=es'
   );
   CurrentWeatherModel currentWeather;
   try{
     final response = await http.get(uri);
     var data = json.decode(response.body.toString());
     if (response.statusCode == 200) {
       print("Req ok");
       currentWeather = CurrentWeatherModel.fromJson(data);
       print("Here now ${currentWeather.current.humidity}");
       return currentWeather;
     } else {
       return null;
       print('Error: ${response.statusCode}');
     }

   }catch (e) {
     print('Exception: $e');
   }
   return null;

 }

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
 title: FutureBuilder<String>(
    future: _readCommunityName(),
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator(); // Muestra un indicador de carga mientras se espera la respuesta
      } else if (snapshot.hasError) {
        return Text(
            'Error: ${snapshot.error}'); // Muestra un mensaje de error si la future se completa con un error
      } else {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage(
                    "images/granjero.png"), // Cambiado a la imagen local
              ),
              const SizedBox(width: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    const Text(
                      'MI COMUNIDAD',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      snapshot.data ??
                           'Default Community Name', // Usa los datos de la future, o un valor predeterminado si la future es null
                      style: const TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                 ],
                ),
              ),
            ]);
      }
    },
 ),
),
      body: Padding(
        padding: EdgeInsets.only(left: 10.0,right: 10.0),
        child: Column(
          children: [
            const Text(
              "El tiempo",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),

            FutureBuilder<CurrentWeatherModel?>(
              future: _getCurrentWeather(),
              builder: (BuildContext context, AsyncSnapshot<CurrentWeatherModel?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Loading state
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Error state
                  return Center(child: Text('An error occurred: ${snapshot.error}'));
                } else {
                  // Data state
                  final weatherData = snapshot.data;
                  if (weatherData == null) {
                    return Center(child: Text('No weather data available'));
                  } else {
                    // Display the weather data in a list using WeatherCard
                    return WeatherCard(weather: weatherData);
                  }
                }
              },
            ),

            const SizedBox(height: 10),
            const Text(
              "Mi parcela",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
            const SizedBox(height: 10),
            const Text(
              "ToDo",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
            Button(
              text: const Text("ToDo", style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ToDo(userId),
                  ),
                );
              },
            ),
            const Text(
              "Map",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
            Button(
              text: const Text("Mapa", style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapPage(userId)
                  ),
                );
              },
            )
          ],
        ),
      )
    );
 }

}