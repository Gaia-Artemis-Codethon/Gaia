import 'dart:convert';

import 'package:flutter_guid/flutter_guid.dart';

class GridDto {
  final Guid id;
  final Guid communityId;
  final int dimensionsX;
  final int dimensionsY;
  //final Map<Guid, List<int>> tileDistribution;
  final Map<String, List<int>> tileDistribution;

  GridDto({
    required this.id,
    required this.communityId,
    required this.dimensionsX,
    required this.dimensionsY,
    required this.tileDistribution,
  });

  static GridDto fromJson(json) {
    return GridDto(
      id: Guid(json[0]['id']),
      communityId: Guid(json[0]['community_id']),
      dimensionsX: int.parse(json[0]['dimensions_X'].toString()),
      dimensionsY: int.parse(json[0]['dimensions_Y'].toString()),
      tileDistribution: parseJson(json[0]['tile_distribution']),
    );
  }
  /*  METHOD FOR Map<Guid,List<int>>
  static Map<Guid, List<int>> parseJson(Map<String, dynamic> jsonMap) {
    Map<Guid, List<int>> resultMap = jsonMap.map((key, value) {
      return MapEntry(Guid(key), List<int>.from(value));
    });
    return resultMap;
  }
   */
  static Map<String, List<int>> parseJson(Map<String, dynamic> jsonMap) {
    Map<String, List<int>> resultMap = jsonMap.map((key, value) {
      return MapEntry(key, List<int>.from(value));
    });
    return resultMap;
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'community_id': communityId,
      'dimensions_X': dimensionsX,
      'dimensions_Y': dimensionsY,
      'tile_distribution': jsonEncode(tileDistribution.map((key, value) => MapEntry(key, value))),
    };
  }
}
