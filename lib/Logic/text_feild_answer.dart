import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';


class PollSummaryTEXT_FEILD extends PollSummary {
  int answeredCount;
  PollSummaryTEXT_FEILD({
    @required this.answeredCount,
    @required int pendingCount,
  }) : super(
          pendingCount: pendingCount,
        );
}

class AnswerTEXT_FEILD extends Answer {
  String answer;
  AnswerTEXT_FEILD({
    @required UserP respondant,
    @required int timestamp,
    @required bool pending,
    @required this.answer,
  }) : super(
          respondant: respondant,
          timestamp: timestamp,
          pending: pending,
        );

  static Stream<PollSummaryTEXT_FEILD> generateSummaryStream(
      Stream<List<AnswerTEXT_FEILD>> answerListStream) {
    return answerListStream.map((map) => generateSummary(map));
  }

  static PollSummaryTEXT_FEILD generateSummary(List<AnswerTEXT_FEILD> answerList) {
    int answeredCount = 0;
    int pendingCount = 0;
    for (AnswerTEXT_FEILD i in answerList) {
      if (i.pending) {
        pendingCount++;
      } else {
        answeredCount++;
      }
    }
    return PollSummaryTEXT_FEILD(
         answeredCount: answeredCount, pendingCount: pendingCount);
  }
}
