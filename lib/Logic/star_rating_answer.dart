import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

enum AnswerEnumSTAR_RATING { ONE, TWO, THREE, FOUR, FIVE }

class PollSummarySTAR_RATING extends PollSummary {
  int oneCount;
  int twoCount;
  int threeCount;
  int fourCount;
  int fiveCount;
  PollSummarySTAR_RATING({
    @required this.oneCount,
    @required this.twoCount,
    @required this.threeCount,
    @required this.fourCount,
    @required this.fiveCount,
    @required int pendingCount,
    @required int totalCount,
  }) : super(
          pendingCount: pendingCount,
          totalCount: totalCount
        );
}

class AnswerSTAR_RATING extends Answer {
  AnswerEnumSTAR_RATING answer;
  AnswerSTAR_RATING({
    @required String respondantId,
    int timestamp,
    @required bool pending,
    @required this.answer,
  }) : super(
          respondantId: respondantId,
          timestamp: timestamp,
          pending: pending,
        ){
          type = AnswerType.STAR_RATING;
        }

  static Stream<PollSummary> generateSummaryStream(
      Stream<List<Answer>> answerListStream) {
    return answerListStream.map((map) => generateSummary(map));
  }

  static AnswerSTAR_RATING fromMap(Map map) {
    return AnswerSTAR_RATING(
      respondantId: map[Answer.RESPONDANT_ID_FEILD],
      pending: map[Answer.PENDING_FEILD],
      timestamp: map[Answer.TIMESTAMP_FEILD],
      answer: answerEnumFromString(map[Answer.ANSWER_FEILD])
    );
  }

  static AnswerEnumSTAR_RATING answerEnumFromString(String str){
    return AnswerEnumSTAR_RATING.values.firstWhere((e) => e.toString() == str);
  }



  @override
  Map<String, dynamic> toMap() {
    return {
      Answer.PENDING_FEILD: this.pending,
      Answer.RESPONDANT_ID_FEILD: this.respondantId,
      Answer.TIMESTAMP_FEILD: timestamp,
      Answer.ANSWER_FEILD: answer.toString(),
      Answer.ANSWER_TYPE_FEILD: AnswerType.STAR_RATING.toString()
    };
  }

  static PollSummary generateSummary(
      List<Answer> answerList) {
    int oneCount = 0;
    int twoCount = 0;
    int threeCount = 0;
    int fourCount = 0;
    int fiveCount = 0;
    int pendingCount = 0;
    int totalCount = 0;
    for (AnswerSTAR_RATING i in answerList) {
      totalCount ++;
      if (i.pending) {
        pendingCount++;
      } else {
        if (i.answer == AnswerEnumSTAR_RATING.ONE) {
          oneCount++;
        } else if (i.answer == AnswerEnumSTAR_RATING.TWO) {
          twoCount++;
        } else if (i.answer == AnswerEnumSTAR_RATING.THREE) {
          threeCount++;
        } else if (i.answer == AnswerEnumSTAR_RATING.FOUR) {
          fourCount++;
        } else if (i.answer == AnswerEnumSTAR_RATING.FIVE) {
          fiveCount++;
        }
      }
    }
    return PollSummarySTAR_RATING(
        oneCount: oneCount,
        twoCount: twoCount,
        threeCount: threeCount,
        fourCount: fourCount,
        fiveCount: fiveCount,
        pendingCount: pendingCount,
        totalCount: totalCount);
  }
}
