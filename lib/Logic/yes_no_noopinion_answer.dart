import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

enum AnswerEnumYES_NO_NOOPINION { YES, NO, NOOPINION}

class PollSummaryYES_NO_NOOPINION extends PollSummary {
  int yesCount;
  int noCount;
  int noOpinionCount;
  PollSummaryYES_NO_NOOPINION({
    @required this.yesCount,
    @required this.noCount,
    @required this.noOpinionCount,
    @required int pendingCount,
  }) : super(
          pendingCount: pendingCount,
        );
}

class AnswerYES_NO_NOOPINION extends Answer {
  AnswerEnumYES_NO_NOOPINION answer;
  AnswerYES_NO_NOOPINION({
    @required User respondant,
    @required int timestamp,
    @required bool pending,
    @required this.answer,
  }) : super(
          respondant: respondant,
          timestamp: timestamp,
          pending: pending,
        );

  static Stream<PollSummaryYES_NO_NOOPINION> generateSummaryStream(
      Stream<List<AnswerYES_NO_NOOPINION>> answerListStream) {
    return answerListStream.map((map) => generateSummary(map));
  }

  static PollSummaryYES_NO_NOOPINION generateSummary(List<AnswerYES_NO_NOOPINION> answerList) {
    int yesCount = 0;
    int noCount = 0;
    int noOpinionCount = 0;
    int pendingCount = 0;
    for (AnswerYES_NO_NOOPINION i in answerList) {
      if (i.pending) {
        pendingCount++;
      } else {
        if (i.answer == AnswerEnumYES_NO_NOOPINION.YES) {
          yesCount++;
        } else if (i.answer == AnswerEnumYES_NO_NOOPINION.NO){
          noCount++;
        }else{
        noOpinionCount++;
        }

      }
    }
    return PollSummaryYES_NO_NOOPINION(
        yesCount: yesCount, noCount: noCount, noOpinionCount: noOpinionCount, pendingCount: pendingCount);
  }
}
