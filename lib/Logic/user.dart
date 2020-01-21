import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:firebase/firebase.dart';
import 'package:meta/meta.dart';

class UserSnapshot {
  String id;
  String name;
  bool isOnline;
  UserSnapshot({
    this.id,
    @required this.name,
    this.isOnline = false,
  });

  Map toMap() {
    return {UserP.NAME_KEY: this.name, UserP.ONLINE_KEY: this.isOnline};
  }
  // Map fromMap()
}

class UserP {
  static const NAME_KEY = "name";
  static const ONLINE_KEY = "isOnline";
  DatabaseInterface database;
  Stream<UserSnapshot> allInfoStream;
  Stream<String> name;
  String id;
  Stream<bool> isOnline;
  UserP({@required this.id, @required this.database}) {
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
        .child(DatabaseInterface.USERS_NODE +
            "/" +
            this.id +
            "/" +
            UserP.NAME_KEY)
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


}
