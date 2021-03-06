import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:convert';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:firebase/firebase.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:meta/meta.dart';

class DatabaseInterface {
  static final Random _random = Random.secure();

  static const String USERS_NODE = "users";
  static const String POLLS_NODE = "polls";
  static const String ACTIVE_POLL_NODE = "active poll";
  static const String NO_ACTIVE_POLL_CODE = "none";
  static const String ADMIN_EMAILS_NODE = "admin emails";
  static const String EMAIL_DOMAINS_NODE = "email domains";
  static const String ANONYMOUS_ID_STORAGE_KEY = "anonymous id";

  SharedPreferences prefs;
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

  static String createCryptoRandomString([int length = 32]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }

  Future<UserP> signIn(UserSnapshot credentials) async {
    await this
        .entryPoint
        .child(DatabaseInterface.USERS_NODE + "/" + credentials.id)
        .set(credentials.toMap());
    return UserP(id: credentials.id, database: this, anonymousId: credentials.anonymousId);
  }

  Future<bool> isAdmin(UserP user) async {
    String email = await user.getEmail();
    String adminEmails = await this.getAdminEmails();
    return adminEmails.contains(email);
  }

  Future<String> getAdminEmails() async {
    return (await this
            .entryPoint
            .child(DatabaseInterface.ADMIN_EMAILS_NODE)
            .once("value"))
        .snapshot
        .val();
  }

  Future<void> setAdminEmails(String adminEmails) async {
    await this
        .entryPoint
        .child(DatabaseInterface.ADMIN_EMAILS_NODE)
        .set(adminEmails);
  }

  Future<String> getEmailDomains() async {
    return (await this
            .entryPoint
            .child(DatabaseInterface.EMAIL_DOMAINS_NODE)
            .once("value"))
        .snapshot
        .val();
  }

  Future<void> setEmailDomains(String emailDomains) async {
    await this
        .entryPoint
        .child(DatabaseInterface.EMAIL_DOMAINS_NODE)
        .set(emailDomains);
  }

  Future<bool> isEmailAuthorized(String email) async {
    String domains = await getEmailDomains();
    String admins = await getAdminEmails();

    if(domains.contains(email.split("@")[1]) || admins.contains(email)){
      return true;
    }
    return false;
  }
  // Future<UserP> signIn(UserSnapshot credentials) async {
  //   print("--SIGN IN--");
  //   Map userFound = (await this
  //           .entryPoint
  //           .child(DatabaseInterface.USERS_NODE)
  //           .orderByChild(UserP.NAME_KEY)
  //           .equalTo(credentials.name)
  //           .once("value"))
  //       .snapshot
  //       .val();
  //   print("user found: " + userFound.toString());

  //   if (userFound != null) {
  //     print("user found");
  //     return UserP(id: userFound.keys.first, database: this);
  //   }
  //   return createUser(credentials);
  // }

  // Future<UserP> createUser(UserSnapshot credentials) async {
  //   print("-- CREATE USER --");
  //   String newUserID =
  //       this.entryPoint.child(DatabaseInterface.USERS_NODE).push().key;
  //   print("id found: " + newUserID);
  //   await this
  //       .entryPoint
  //       .child(DatabaseInterface.USERS_NODE + "/" + newUserID)
  //       .set(credentials.toMap());
  //   return UserP(id: newUserID, database: this);
  // }

  void setOnlineStatusHooks(UserP user) {
    DatabaseReference ref = this.entryPoint.child(
        DatabaseInterface.USERS_NODE + "/" + user.id + "/" + UserP.ONLINE_KEY);
    ref.set(true);
    ref.onDisconnect().set(false);
  }

  Future<String> getAnonymousId() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    String id = prefs.getString(DatabaseInterface.ANONYMOUS_ID_STORAGE_KEY);
    if (id == null) {
      id = createCryptoRandomString(32);
      prefs.setString(DatabaseInterface.ANONYMOUS_ID_STORAGE_KEY, id);
    }
    return id;
  }

  Future<Poll> createPoll(PollSnapshot pollInfo) async {
    print("-- CREATE POLL --");
    String newPollID =
        this.entryPoint.child(DatabaseInterface.POLLS_NODE).push().key;
    print("id found: " + newPollID);
    await this
        .entryPoint
        .child(DatabaseInterface.POLLS_NODE + "/" + newPollID)
        .set(pollInfo.toMap());

    Poll poll = Poll(id: newPollID, database: this);
    await poll.initializeConstantData();
    return poll;
  }

  Future<Map> lastTenPolls() async {
    Map answer = ((await this
            .entryPoint
            .child(DatabaseInterface.POLLS_NODE)
            .limitToLast(10)
            .once("value")))
        .snapshot
        .val();
    if (answer == null) {
      return {};
    }
    return answer;
  }

  Stream getActivePollId() {
    return this
        .entryPoint
        .child(DatabaseInterface.ACTIVE_POLL_NODE)
        .onValue
        .map((data) {
      return data.snapshot.val();
    }).distinct();
  }

  Future<void> setActivePollId(String pollId) async {
    await this.entryPoint.child(DatabaseInterface.ACTIVE_POLL_NODE).set(pollId);
  }

  Future<void> deletePoll(String pollId) async {
    await this
        .entryPoint
        .child(DatabaseInterface.POLLS_NODE)
        .child(pollId)
        .remove();
  }

  Future<void> endCurrentPoll() async {
    await this
        .entryPoint
        .child(DatabaseInterface.ACTIVE_POLL_NODE)
        .set(DatabaseInterface.NO_ACTIVE_POLL_CODE);
  }

  Stream allUsersStream() {
    return this
        .entryPoint
        .child(DatabaseInterface.USERS_NODE)
        .onValue
        .map((QueryEvent data) {
      if (data.snapshot.exists()) {
        List<UserSnapshot> users = List();
        for (Map i in (data.snapshot.val() as Map).values) {
          users.add(UserSnapshot(
              name: i[UserP.NAME_KEY], isOnline: i[UserP.ONLINE_KEY]));
        }

        return users;
      }

      return null;
    });
  }
}
