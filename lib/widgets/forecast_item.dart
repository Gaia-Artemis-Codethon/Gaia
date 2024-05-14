import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/custom_image.dart';
import '../models/forecast_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ForecastItem extends StatelessWidget {
  final ForecastDay weather;
  const ForecastItem({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            CustomCachedImage(
              imageUrl: 'https:${weather.day.condition.icon}',
              fit: BoxFit.cover,
              width: 125,
              height: 125,
              color: Colors.white,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              children: [
                Text(
                  getWeekDayFromDate(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  getDayMonthFromDate(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white),
                ),
              ],
            )
          ],
        ),
        Column(
          children: [
            Text(
              "${weather.day.avgTemp} °C",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.white),
            )
          ],
        )
      ],
    );
  }

  String getWeekDayFromDate() {
    DateTime date = DateTime.parse(weather.date);
    String weekDay = DateFormat('EEEE', 'en').format(date);
    weekDay = weekDay.substring(0, 1).toUpperCase() + weekDay.substring(1);
    return weekDay;
  }

  String getDayMonthFromDate() {
    DateTime date = DateTime.parse(weather.date);
    String day = DateFormat('d', 'en').format(date);
    String month = DateFormat('MMMM', 'en').format(date);
    return '$month, $day ';
  }
}
