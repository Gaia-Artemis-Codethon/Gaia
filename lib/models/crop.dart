import 'package:flutter_guid/flutter_guid.dart';

class Crop{
  final Guid id;
  final String name;
  final String season;
  final int difficulty;
  final String descript;
  final String thumbnail;

  Crop({required this.id, required this.name, required this.season, required this.difficulty, required this.descript, required this.thumbnail});

  static String getCropName(Crop crop) {
    return crop.name;
  }

  static int parseDifficulty(String difficulty) {
    switch (difficulty) {
      case 'Low':
        return 1;
      case 'Medium':
        return 2;
      case 'High':
        return 3;
      default:
        return 0;
    }
  }

  static Map<String, dynamic> toJson(Crop crop){
    return {
        "id": crop.id.value,
        "name": crop.name,
        "season": crop.season,
        "difficulty": crop.difficulty,
        "descript": crop.descript,
        "thumbnail": crop.thumbnail
      };
  }

  static Crop fromJson(data){
    return Crop(
        id: Guid(data[0]['id']),
        name: data[0]['name'],
        season: data[0]['season'],
        difficulty: data[0]['difficulty'],
        descript: data[0]['descript'],
        thumbnail: data[0]['thumbnail']
      );
  }
}