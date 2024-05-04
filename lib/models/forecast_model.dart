class ForecastModel {
  final Forecast forecast;

  ForecastModel({required this.forecast});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      forecast: Forecast.fromJson(json['forecast']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'forecast': forecast.toJson(),
    };
  }
}

class Forecast {
  final List<ForecastDay> forecastDay;

  Forecast({
    required this.forecastDay
  });

  factory Forecast.fromJson(Map<String, dynamic> json){
    return Forecast(
      forecastDay: List<ForecastDay>.from(json['forecastday'].map((x) => ForecastDay.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'forecastDay': List<dynamic>.from(forecastDay.map((x) => x.toJson())),
    };
  }
}

class ForecastDay {
  final String date;
  final Day day;
  final List<Hour> hour;


  ForecastDay({
    required this.date,
    required this.day,
    required this.hour
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json){
    return ForecastDay(
        date: json['date'],
        day: Day.fromJson(json['day']),
        hour: List<Hour>.from(json['hour'].map((x) => Hour.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'day': day,
      'hour': List<dynamic>.from(hour.map((x) => x.toJson())),
    };
  }
}

class Day{
  final double avgTemp;
  final double maxWind;
  final int avgHumidity;
  final int chanceRain;
  final Condition condition;

  Day({
    required this.avgTemp,
    required this.maxWind,
    required this.avgHumidity,
    required this.chanceRain,
    required this.condition
  });

  factory Day.fromJson(Map<String, dynamic> json){
    return Day(
        avgTemp: json['avgtemp_c'],
        maxWind: json['maxwind_kph'],
        avgHumidity: json['avghumidity'],
        chanceRain: json['daily_chance_of_rain'],
        condition: Condition.fromJson(json['condition'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avgtemp_c': avgTemp,
      'maxwind_kph': maxWind,
      'avghumidity': avgHumidity,
      'daily_chance_of_rain': chanceRain,
      'condition': condition
    };
  }

}

class Hour {
  String time;
  double tempC;
  Condition condition;

  Hour({
    required this.time,
    required this.tempC,
    required this.condition,
  });

  factory Hour.fromJson(Map<String, dynamic> json) => Hour(
    time: json['time'],
    tempC: json['temp_c']?.toDouble(),
    condition: Condition.fromJson(json['condition']),
  );

  Map<String, dynamic> toJson() => {
    'time': time,
    'temp_c': tempC,
    'condition': condition.toJson(),
  };
}

class Condition {
  String icon;

  Condition({
    required this.icon,
  });

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
    icon: json['icon'],
  );

  Map<String, dynamic> toJson() => {
    'icon': icon,
  };
}


