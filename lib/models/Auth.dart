import 'package:flutter_guid/flutter_guid.dart';

class Auth {
  Auth._();

  static final Auth _instance = Auth._();

  factory Auth() => _instance;

  late Guid _id;
  late String _username;
  late Guid _community;
  late bool _isAdmin;

  Guid get id => _id;
  String get username => _username;
  Guid get community => _community;
  bool get isAdmin => _isAdmin;

  void initialize({
    required Guid id,
    required String username,
    required Guid community,
    required bool isAdmin,
  }) {
    _id = id;
    _username = username;
    _community = community;
    _isAdmin = isAdmin;
  }
}
