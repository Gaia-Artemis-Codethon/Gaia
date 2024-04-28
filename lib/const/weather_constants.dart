import '../models/forecast_model.dart';

class Constants {
  // api key
  static const apiKey = '6164cf989b99407a9bb45846242604';


  // api urls
  static const baseUrl = 'http://api.weatherapi.com/v1';
  static const currentWeatherApiUrl = '$baseUrl/current.json';
  static const forecastWeatherApiUrl = '$baseUrl/forecast.json';

  // api fields
  static const key = 'key';
  static const q = 'q';
  static const days = 'days';
  static const lang = 'lang';

  // api default values
  static const defaultLang = 'es';
  static const defaultDays = '3';
}