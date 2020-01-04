import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/star_rating_answer.dart';
import 'package:blueberrypoll/Logic/text_feild_answer.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:blueberrypoll/Logic/yes_no_answer.dart';
import 'package:blueberrypoll/Logic/yes_no_noopinion_answer.dart';
import 'package:meta/meta.dart';

enum AnswerType { YES_NO, YES_NO_NOOPINION, TEXT_FEILD, STAR_RATING }

class Answer {
  static Map answerTypeClassMap = {
    AnswerType.YES_NO: AnswerYES_NO,
    AnswerType.YES_NO_NOOPINION: AnswerYES_NO_NOOPINION,
    AnswerType.TEXT_FEILD: AnswerTEXT_FEILD,
    AnswerType.STAR_RATING: AnswerSTAR_RATING
  };
  bool pending;
  User respondant;
  int timestamp;

  Answer({
    @required this.respondant,
    @required this.timestamp,
    @required this.pending,
  });
}

class PollSummary {
  Poll parentPoll;
  bool isAnonymous;
  bool areResultsVisible;
  bool hasResultVisibilityPrivilege;
  int pendingCount;

  PollSummary({
    @required this.pendingCount,
  });

  // void setAnonymity(bool anonymity)
  // void setVisibility(bool visibility)

}
