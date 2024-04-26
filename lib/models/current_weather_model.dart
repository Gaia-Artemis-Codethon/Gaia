class CurrentWeatherModel {
  final Location location;
  final Current current;

  CurrentWeatherModel({required this.location, required this.current});

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      location: Location.fromJson(json['location']),
      current: Current.fromJson(json['current']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'current': current.toJson(),
    };
  }
}

class Location {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String tzId;
  final int localtimeEpoch;
  final String localtime;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
      tzId: json['tz_id'],
      localtimeEpoch: json['localtime_epoch'],
      localtime: json['localtime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'region': region,
      'country': country,
      'lat': lat,
      'lon': lon,
      'tz_id': tzId,
      'localtime_epoch': localtimeEpoch,
      'localtime': localtime,
    };
  }
}

class Current {
  final int humidity;
  final double wind;
  final double temp;
  Condition condition;

  Current({
    required this.condition,
    required this.humidity,
    required this.wind,
    required this.temp,


  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      humidity: json['humidity'],
      wind: json['gust_kph'],
      temp: json['temp_c'],
      condition: Condition.fromJson(json['condition']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'condition': condition,
      'humidity': humidity,
      'gust_kph': wind,
      'temp_c': temp,
    };
  }
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

