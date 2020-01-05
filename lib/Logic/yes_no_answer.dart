import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

enum AnswerEnumYES_NO { YES, NO }

class PollSummaryYES_NO extends PollSummary {
  int yesCount;
  int noCount;
  PollSummaryYES_NO({
    @required this.yesCount,
    @required this.noCount,
    @required int pendingCount,
    @required int totalCount,
  }) : super(
          pendingCount: pendingCount,
          totalCount: totalCount,
        );
}

class AnswerYES_NO extends Answer {
  AnswerEnumYES_NO answer;
  AnswerYES_NO({
    @required String respondantId,
    int timestamp,
    @required bool pending,
    @required this.answer,
  }) : super(
          respondantId: respondantId,
          timestamp: timestamp,
          pending: pending,
        );

    static AnswerYES_NO fromMap(Map map) {
    return AnswerYES_NO(
      respondantId: map[Answer.RESPONDANT_ID_FEILD],
      pending: map[Answer.PENDING_FEILD],
      timestamp: map[Answer.TIMESTAMP_FEILD],
      answer: answerEnumFromString(map[Answer.ANSWER_FEILD])
    );
  }

  static AnswerEnumYES_NO answerEnumFromString(String str){
    return AnswerEnumYES_NO.values.firstWhere((e) => e.toString() == str);
  }



  @override
  Map<String,dynamic> toMap(){
    return {
      Answer.PENDING_FEILD : this.pending,
      Answer.RESPONDANT_ID_FEILD : this.respondantId,
      Answer.TIMESTAMP_FEILD : timestamp,
      Answer.ANSWER_FEILD : answer.toString(),
      Answer.ANSWER_TYPE_FEILD: AnswerType.YES_NO.toString()
    };
  }

  static Stream<PollSummaryYES_NO> generateSummaryStream(
      Stream<List<Answer>> answerListStream) {
    return answerListStream.map((map) => generateSummary(map));
  }

  static PollSummaryYES_NO generateSummary(List<Answer> answerList) {
    int yesCount = 0;
    int noCount = 0;
    int pendingCount = 0;
    int totalCount = 0;
    for (AnswerYES_NO i in answerList) {
      totalCount++;
      if (i.pending) {
        pendingCount++;
      } else {
        if (i.answer == AnswerEnumYES_NO.YES) {
          yesCount++;
        } else {
          noCount++;
        }
      }
    }
    return PollSummaryYES_NO(
        yesCount: yesCount, noCount: noCount, pendingCount: pendingCount, totalCount: totalCount);
  }
}
