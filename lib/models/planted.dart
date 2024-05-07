import 'package:flutter_guid/flutter_guid.dart';

class Planted{
  final Guid id;
  final Guid user_id;
  final Guid crop_id;
  final Guid land_id;
  final DateTime planted_time;
  final int status;
  final int perenual_id;

  Planted({required this.id, required this.user_id, required this.crop_id, required this.land_id, required this.planted_time, required this.status, required this.perenual_id});

  static Planted fromJson(Map<String, dynamic> data) {
    print('mapping one');
    return Planted(
        id: Guid(data[0]['id']),
        user_id: Guid(data[0]['user_id']),
        crop_id: data[0]['crop_id'],
        land_id: data[0]['land_id'],
        planted_time: data[0]['planted_time'],
        status: data[0]['difficulty'],
        perenual_id: data[0]['perenual_id']
      );
  }

  static Map<String, dynamic> toJson(Planted plant){
    return {
        "id": plant.id.value,
        "user_id": plant.user_id.value,
        "crop_id": plant.crop_id.value,
        "land_id": plant.land_id.value,
        "planted_time": plant.planted_time.toIso8601String(),
        "status": plant.status,
        "perenual_id": plant.perenual_id
      };
  }

  static String parseStatus(int status) {
    switch(status) {
      case 0:
        return 'Seed';
      case 1:
        return 'Germination';
      case 2:
        return 'Seedling';
      case 3:
        return 'Vegetative Growth';
      case 4:
        return 'Flowering';
      case 5:
        return 'Fruit formation';
      case 6:
        return 'Senescence';
      default:
        return 'Unknown';
    }

  }
}