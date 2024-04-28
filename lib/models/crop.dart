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
}