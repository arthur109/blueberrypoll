import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:meta/meta.dart';

class UserSnapshot {
  String id;
  String name;
  String organization;
  bool isOnline;
  UserSnapshot({
    @required this.id,
    @required this.name,
    @required this.organization,
    @required this.isOnline,
  });

  // Map toJson()
  // Map fromJson()
}

class User {
  DatabaseInterface database;
  Stream<UserSnapshot> allInfoStream;
  Stream<String> name;
  String organization;
  String id;
  Stream<bool> isOnline;
  User({
    @required  this.id,
    @required this.database,
  });
}

