import 'package:flutter_guid/flutter_guid.dart';

class UserLoged{
  final Guid id;
  String name;
  String email;
  Guid? community_id;
  bool? is_admin;

  UserLoged({required this.id, required this.name, required this.email,  this.community_id, this.is_admin});
}