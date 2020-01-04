import 'package:firebase/firebase.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:meta/meta.dart';

class DatabaseInterface {
  static const String USERS_NODE = "users";
  String rootNode;
  String organization;
  DatabaseReference entryPoint;
  Database server;
  DatabaseInterface({@required this.organization}) {
    initializeApp(
        apiKey: "AIzaSyDZ_zGoNqGa0qnpWhUYnBciAY2cm_mS924",
        authDomain: "blueberry-poll-one.firebaseapp.com",
        databaseURL: "https://blueberry-poll-one.firebaseio.com",
        projectId: "blueberry-poll-one",
        storageBucket: "blueberry-poll-one.appspot.com",
        messagingSenderId: "176622864765",
        appId: "1:176622864765:web:079ec753ca85e82ae9e414",
        measurementId: "G-63200ZDRD0");
    analytics();
    server = database();
    rootNode = this.organization;
    entryPoint = server.ref(rootNode);
  }

  


  Future<UserP> signIn(UserSnapshot credentials) async {
    print("--SIGN IN--");
    Map userFound = (await this
            .entryPoint
            .child(DatabaseInterface.USERS_NODE)
            .orderByChild(UserP.NAME_FEILD)
            .equalTo(credentials.name)
            .once("value"))
        .snapshot
        .val();
    print("user found: " + userFound.toString());

    if (userFound != null) {
      print("user found");
      return UserP(id: userFound.keys.first, database: this);
    }
    return createUser(credentials);
  }

  Future<UserP> createUser(UserSnapshot credentials) async {
    print("-- CREATE USER --");
    String newUserID =
        this.entryPoint.child(DatabaseInterface.USERS_NODE).push().key;
    print("id found: " + newUserID);
    await this
        .entryPoint
        .child(DatabaseInterface.USERS_NODE + "/" + newUserID)
        .set(credentials.toMap());
    return UserP(id: newUserID, database: this);
  }

  void setOnlineStatusHooks(UserP user) {
    DatabaseReference ref = this.entryPoint.child(DatabaseInterface.USERS_NODE +
        "/" +
        user.id +
        "/" +
        UserP.ONLINE_FEILD);
    ref.set(true);
    ref.onDisconnect().set(false);
  }
}
