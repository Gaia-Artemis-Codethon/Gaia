import 'package:flutter_guid/flutter_guid.dart';

class Planted{
  final Guid id;
  final Guid user_id;
  final Guid crop_id;
  final Guid land_id;
  final DateTime planted_time;
  final int status;

  Planted({required this.id, required this.user_id, required this.crop_id, required this.land_id, required this.planted_time, required this.status});

  static fromJson(Map<String, dynamic> json) {
    print('mapping one');
    return Planted(
      id: Guid(json['id']),
      user_id: Guid(json['user_id']),
      crop_id: Guid(json['crop_id']),
      land_id: Guid(json['land_id']),
      planted_time: json['planted_time'],
      status: json['status']
    );
  }

  static String parseStatus(int status) {
    switch(status) {
      case 0:
        return '1';
      case 1:
        return '2';
      case 2:
        return '3';
      case 3:
        return '4';
      case 4:
        return '5';
      case 5:
        return '6';
      case 6:
        return '7';
      default:
        return 'Unknown';
    }

  }
}