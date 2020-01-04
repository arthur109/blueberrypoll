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
  }) : super(
          pendingCount: pendingCount,
        );
}

class AnswerSTAR_RATING extends Answer {
  AnswerEnumSTAR_RATING answer;
  AnswerSTAR_RATING({
    @required User respondant,
    @required int timestamp,
    @required bool pending,
    @required this.answer,
  }) : super(
          respondant: respondant,
          timestamp: timestamp,
          pending: pending,
        );

  static Stream<PollSummarySTAR_RATING> generateSummaryStream(
      Stream<List<AnswerSTAR_RATING>> answerListStream) {
    return answerListStream.map((map) => generateSummary(map));
  }

  static PollSummarySTAR_RATING generateSummary(
      List<AnswerSTAR_RATING> answerList) {
   int oneCount = 0;
  int twoCount = 0;
  int threeCount = 0;
  int fourCount = 0;
  int fiveCount = 0;
    int pendingCount = 0;
    for (AnswerSTAR_RATING i in answerList) {
      if (i.pending) {
        pendingCount++;
      } else {
        if (i.answer == AnswerEnumSTAR_RATING.ONE) {
          oneCount++;
        } else if (i.answer == AnswerEnumSTAR_RATING.TWO)  {
          twoCount++;
        }else if (i.answer == AnswerEnumSTAR_RATING.THREE)  {
          threeCount++;
        }else if (i.answer == AnswerEnumSTAR_RATING.FOUR)  {
          fourCount++;
        }else if (i.answer == AnswerEnumSTAR_RATING.FIVE)  {
          fiveCount++;
        }
      }
    }
    return PollSummarySTAR_RATING(
        oneCount: oneCount, twoCount: twoCount, threeCount: threeCount, fourCount: fourCount, fiveCount: fiveCount, pendingCount: pendingCount);
  }
}
