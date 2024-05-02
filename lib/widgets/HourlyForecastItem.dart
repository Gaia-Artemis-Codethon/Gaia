import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/custom_image.dart';
import '../models/forecast_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HourlyForecastItem extends StatelessWidget {
  final Hour weather;
  const HourlyForecastItem({required this.weather});


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
      Container(
          width: 105,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0XFFFFFFFF),
                Color(0X8AFFFFFF),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
              children:[
                SizedBox(height:3),
                Text(
                  getHour(weather.time),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                CustomCachedImage(
                  imageUrl: 'https:${weather.condition.icon}',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 75,
                  color: Colors.white,
                ),
                Text(
                  '${weather.tempC.ceil()}°C',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ]
          ),
        ),
        SizedBox(
          width: 5,
        )
      ],
    );
  }

  String getHour(String time) {
    if (time.length <= 5) {
      return time;
    }
    return time.substring(time.length - 5);
  }
}