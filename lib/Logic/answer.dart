import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/star_rating_answer.dart';
import 'package:blueberrypoll/Logic/text_feild_answer.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/Logic/yes_no_answer.dart';
import 'package:blueberrypoll/Logic/yes_no_noopinion_answer.dart';
import 'package:meta/meta.dart';

enum AnswerType { YES_NO, YES_NO_NOOPINION, TEXT_FEILD, STAR_RATING }

class Answer {
  static const String PENDING_FEILD = "is pending";
  static const String RESPONDANT_ID_FEILD = "respondant id";
  static const String TIMESTAMP_FEILD = "timestamp";
  static const String ANSWER_FEILD = "answer";
  static const String ANSWER_TYPE_FEILD = "answer type";

  bool pending;
  String respondantId;
  int timestamp;

  Answer({
    @required this.respondantId,
    this.timestamp,
    @required this.pending,
  }){
  if(this.timestamp == null){
      this.timestamp = DateTime.now().millisecondsSinceEpoch;
    }
  }



  Map<String,dynamic> toMap(){
    return {
      Answer.PENDING_FEILD : this.pending,
      Answer.RESPONDANT_ID_FEILD : this.respondantId,
      Answer.TIMESTAMP_FEILD : timestamp,
      Answer.ANSWER_FEILD : null
    };
  }
}

class PollSummary {
  Poll parentPoll;
  bool isAnonymous;
  bool areResultsVisible;
  bool hasResultVisibilityPrivilege;
  int pendingCount;
  int totalCount;

  PollSummary({
    @required this.pendingCount,
    @required this.totalCount,
  });


  // void setAnonymity(bool anonymity)
  // void setVisibility(bool visibility)

}
