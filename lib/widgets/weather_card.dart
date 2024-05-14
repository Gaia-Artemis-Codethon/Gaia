import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocode/geocode.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../components/custom_image.dart';
import '../const/weather_constants.dart';
import '../models/current_weather_model.dart';
import '../models/forecast_model.dart';
import '../pages/forecast/forecast_page.dart';

class WeatherCard extends StatelessWidget {
  final CurrentWeatherModel weather;
  const WeatherCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForecastPage(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7CB9FF),
              Color(0xFF5162FF),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomCachedImage(
                    imageUrl: 'https:${weather.current.condition.icon}',
                    fit: BoxFit.cover,
                    width: 125,
                    height: 125,
                    color: Colors.white,
                  ),
                  Text(
                    '${weather.location.name}',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    '${weather.current.temp.ceil()}° Celsius',
                    style: theme.textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ],
              ).animate().slideX(
                    duration: 200.ms,
                    begin: -1,
                    curve: Curves.easeInSine,
                  ),
            ),
            Column(
              children: [
                SizedBox(height: 25),
                Row(
                  children: [
                    Text(
                      "Wind",
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  // Adding a Row widget
                  children: [
                    SvgPicture.asset('images/wind.svg'),
                    Text(
                      '${weather.current.wind}' + " Km/h",
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 13),
                Text(
                  "Humidity",
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  // Adding a Row widget
                  children: [
                    SvgPicture.asset('images/humidity.svg'),
                    Text(
                      '${weather.current.humidity} %',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                )
              ],
            ).animate().slideX(
                  duration: 200.ms,
                  begin: 1,
                  curve: Curves.easeInSine,
                ),
          ],
        ),
      ),
    );
  }
}
