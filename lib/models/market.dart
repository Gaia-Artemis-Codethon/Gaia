import 'package:flutter_guid/flutter_guid.dart';

class Market {
  final Guid id;
  final Guid user;
  final String title;
  final String? description;
  final Guid community;
  final String username;

  Market({
    required this.id,
    required this.user,
    required this.title,
    this.description,
    required this.community,
    required this.username
  });

  static Market fromJson(Map<String, dynamic> json) {
    return Market(
      id: Guid(json['id']),
      user: Guid(json['user']),
      title: json['title'],
      description: json['description'] ?? 'No description',
      community: Guid(json['community']),
      username: json['username']
    );
  }

  static Map<String, dynamic> toJson(Market market) {
    return {
      "id": market.id.value,
      "user": market.user.value,
      "title": market.title,
      "description": market.description,
      "community": market.community.value,
      "username": market.username
    };
  }
}