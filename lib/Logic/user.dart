import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:firebase/firebase.dart';
import 'package:meta/meta.dart';

class UserSnapshot {
  String id;
  String anonymousId;
  String name;
  String email;
  bool isOnline;
  UserSnapshot({
    this.id,
    @required this.name,
    this.isOnline = false,
    this.email,
    this.anonymousId
  });

  Map toMap() {
    return {UserP.NAME_KEY: this.name, UserP.ONLINE_KEY: this.isOnline, UserP.EMAIL_KEY: this.email};
  }
  // Map fromMap()
}

class UserP {
  static const NAME_KEY = "name";
  static const ONLINE_KEY = "isOnline";
  static const EMAIL_KEY = "email";
  DatabaseInterface database;
  Stream<UserSnapshot> allInfoStream;
  Stream<String> email;
  Stream<String> name;
  String id;
  String anonymousId;
  Stream<bool> isOnline;
  UserP({@required this.id, @required this.database, this.anonymousId}) {
    this.allInfoStream = this
        .database
        .entryPoint
        .child(DatabaseInterface.USERS_NODE + "/" + this.id)
        .onValue
        .map((QueryEvent data) {
      Map userMap = data.snapshot.val();
      return UserSnapshot(
          id: this.id,
          name: userMap[UserP.NAME_KEY],
          isOnline: userMap[UserP.ONLINE_KEY]);
    });

    this.name = this
        .database
        .entryPoint
        .child(
            DatabaseInterface.USERS_NODE + "/" + this.id + "/" + UserP.NAME_KEY)
        .onValue
        .map((QueryEvent data) {
      return data.snapshot.val();
    });

    this.email = this
        .database
        .entryPoint
        .child(
            DatabaseInterface.USERS_NODE + "/" + this.id + "/" + UserP.EMAIL_KEY)
        .onValue
        .map((QueryEvent data) {
      return data.snapshot.val();
    });

    this.isOnline = this
        .database
        .entryPoint
        .child(DatabaseInterface.USERS_NODE +
            "/" +
            this.id +
            "/" +
            UserP.ONLINE_KEY)
        .onValue
        .map((QueryEvent data) {
      return data.snapshot.val();
    });
  }

  Future<String> getName() async {
    return (await this
            .database
            .entryPoint
            .child(DatabaseInterface.USERS_NODE +
                "/" +
                this.id +
                "/" +
                UserP.NAME_KEY)
            .once("value"))
        .snapshot
        .val();
  }

  Future<String> getEmail() async {
    return (await this
            .database
            .entryPoint
            .child(DatabaseInterface.USERS_NODE +
                "/" +
                this.id +
                "/" +
                UserP.EMAIL_KEY)
            .once("value"))
        .snapshot
        .val();
  }
}
