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
  }) : super(
          pendingCount: pendingCount,
        );
}

class AnswerYES_NO extends Answer {
  AnswerEnumYES_NO answer;
  AnswerYES_NO({
    @required User respondant,
    @required int timestamp,
    @required bool pending,
    @required this.answer,
  }) : super(
          respondant: respondant,
          timestamp: timestamp,
          pending: pending,
        );

  static Stream<PollSummaryYES_NO> generateSummaryStream(
      Stream<List<AnswerYES_NO>> answerListStream) {
    return answerListStream.map((map) => generateSummary(map));
  }

  static PollSummaryYES_NO generateSummary(List<AnswerYES_NO> answerList) {
    int yesCount = 0;
    int noCount = 0;
    int pendingCount = 0;
    for (AnswerYES_NO i in answerList) {
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
        yesCount: yesCount, noCount: noCount, pendingCount: pendingCount);
  }
}
