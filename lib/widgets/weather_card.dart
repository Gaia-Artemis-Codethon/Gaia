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


class WeatherCard extends StatelessWidget {
final CurrentWeatherModel weather;
const WeatherCard({required this.weather});


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCachedImage(
                    imageUrl: 'https:${weather.current.condition.icon}',
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                    color: Colors.white,
                  ),
                  Text(
                    '${weather.current.temp} Celsius',
                    style: theme.textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 18
                    ),
                  ),
                ],
              ).animate().slideX(
                duration: 200.ms, begin: -1, curve: Curves.easeInSine,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Viento",
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                Row( // Adding a Row widget
                  children: [
                    SvgPicture.asset('images/vectors/wind.svg'), // Replace 'assets/your_image.png' with your image path
                    Text(
                      '${weather.current.wind}'+" Km/h",
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Humedad",
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                Row( // Adding a Row widget
                  children: [
                    SvgPicture.asset('images/vectors/humidity.svg'), // Replace 'assets/your_image.png' with your image path
                    Text(
                      '${weather.current.humidity} %',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ).animate().slideX(
              duration: 200.ms, begin: 1, curve: Curves.easeInSine,
            ),
          ],
        ),
      ),
    );
  }


}