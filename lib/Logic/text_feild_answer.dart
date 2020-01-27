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
    @required int totalCount,
  }) : super(
          pendingCount: pendingCount,
          totalCount: totalCount,
        );
}

class AnswerTEXT_FEILD extends Answer {
  String answer;
  AnswerTEXT_FEILD({
    @required String respondantId,
    int timestamp,
    @required bool pending,
    @required this.answer,
  }) : super(
          respondantId: respondantId,
          timestamp: timestamp,
          pending: pending,
        ){
          type = AnswerType.TEXT_FEILD;
        }
  static AnswerTEXT_FEILD fromMap(Map map) {
    return AnswerTEXT_FEILD(
      respondantId: map[Answer.RESPONDANT_ID_FEILD],
      pending: map[Answer.PENDING_FEILD],
      timestamp: map[Answer.TIMESTAMP_FEILD],
      answer: map[Answer.ANSWER_FEILD]
    );
  }


  @override
  Map<String,dynamic> toMap(){
    return {
      Answer.PENDING_FEILD : this.pending,
      Answer.RESPONDANT_ID_FEILD : this.respondantId,
      Answer.TIMESTAMP_FEILD : timestamp,
      Answer.ANSWER_FEILD : answer.toString(),
      Answer.ANSWER_TYPE_FEILD: AnswerType.TEXT_FEILD.toString()
    };
  }
  
  static Stream<PollSummary> generateSummaryStream(
      Stream<List<Answer>> answerListStream) {
    return answerListStream.map((map) => generateSummary(map));
  }

  static PollSummaryTEXT_FEILD generateSummary(List<Answer> answerList) {
    int answeredCount = 0;
    int pendingCount = 0;
    int totalCount = 0;
    for (AnswerTEXT_FEILD i in answerList) {
      totalCount++;
      if (i.pending) {
        pendingCount++;
      } else {
        answeredCount++;
      }
    }
    return PollSummaryTEXT_FEILD(
         answeredCount: answeredCount, pendingCount: pendingCount, totalCount: totalCount);
  }
}
