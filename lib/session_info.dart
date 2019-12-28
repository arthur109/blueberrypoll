import 'package:firebase/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionInfo {
  static Database database;
  static String organization = "orange_logic";
  static String name;
  static String userID;
  static SharedPreferences storage;
}

enum AnswerType { YES_NO, YES_NO_NOOPINION, TEXT_FEILD, STAR_RATING }
enum PrivacyType { ANONYMOUS, SHOW_NAMES }

