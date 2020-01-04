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
    return {UserP.NAME_FEILD: this.name, UserP.ONLINE_FEILD: this.isOnline};
  }
  // Map fromMap()
}

class UserP {
  static const NAME_FEILD = "name";
  static const ONLINE_FEILD = "isOnline";
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
          name: userMap[UserP.NAME_FEILD],
          isOnline: userMap[UserP.ONLINE_FEILD]);
    });

    this.name = this
        .database
        .entryPoint
        .child(DatabaseInterface.USERS_NODE +
            "/" +
            this.id +
            "/" +
            UserP.NAME_FEILD)
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
            UserP.ONLINE_FEILD)
        .onValue
        .map((QueryEvent data) {
      return data.snapshot.val();
    });
  }
}
