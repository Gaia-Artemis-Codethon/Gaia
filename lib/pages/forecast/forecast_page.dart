import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_huerto/widgets/forecast_item.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../const/weather_constants.dart';
import '../../models/forecast_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ForecastPage extends StatefulWidget {
  ForecastPage();

  @override
  _ForecastState createState() => _ForecastState();
}

class _ForecastState extends State<ForecastPage> {
  ForecastModel _forecast = ForecastModel(
    forecast: Forecast(
      forecastDay: [
        ForecastDay(
          date: '2024-01-01',
          day: Day(
            avgTemp: 0,
            maxWind: 0,
            avgHumidity: 0,
            chanceRain: 0,
            condition: Condition(
              icon: '',
            ),
          ),
        ),
      ],
    ),
  );
  List<ForecastDay> _list = [];

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
    _fetchForecast().then((_) {
      _list = _forecast.forecast.forecastDay;
      build(context);
    });
  }

  String getFormattedDate() {
    DateTime now = DateTime.now();
    String dayOfWeek = DateFormat('EEEE', 'es').format(now);
    String dayOfMonth = DateFormat('d', 'es').format(now);
    String month = DateFormat('MMMM', 'es').format(now);
    return "Hoy $dayOfWeek $dayOfMonth de $month";
  }

  Future<void> _fetchForecast() async {
    String? city = await getCurrentLocation();
    if (city == null) {
      city = "Valencia";
    }
    if (city == "Valencia") {
      city = city + ",ES";
    } //ToDo: Do not hardcode in case of conflict

    final Uri uri = Uri.parse(
        '${Constants.forecastWeatherApiUrl}?${Constants.key}=${Constants.apiKey}&${Constants.q}=${city}&${Constants.lang}=${Constants.defaultLang}&${Constants.days}=${Constants.defaultDays}');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print(json);
        setState(() {
          _forecast = ForecastModel.fromJson(json);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF7CB9FF),
          title: Text(
            "Previsión Meteorológica",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 40),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0,
        ),
        body: _forecast.forecast.forecastDay.length < 3
            ? DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color(0xFF7CB9FF),
                        Color(0xFF5162FF),
                      ]),
                ),
                child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white))))
            : DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color(0xFF7CB9FF),
                        Color(0xFF5162FF),
                      ]),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("${getFormattedDate()}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Jaja se me olvido, no tengo el model hecho",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    SingleChildScrollView(
                        padding:
                            EdgeInsets.only(top: 10.0, left: 20, right: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: _list.length,
                              itemBuilder: (context, index) {
                                return ForecastItem(weather: _list[index]);
                              },
                            ),
                          ],
                        ))
                  ],
                )));
  }
}
