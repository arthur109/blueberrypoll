import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

enum AnswerEnumYES_NO_NOOPINION { YES, NO, NOOPINION }

class PollSummaryYES_NO_NOOPINION extends PollSummary {
  int yesCount;
  int noCount;
  int noOpinionCount;
  PollSummaryYES_NO_NOOPINION({
    @required this.yesCount,
    @required this.noCount,
    @required this.noOpinionCount,
    @required int pendingCount,
    @required int totalCount,
  }) : super(
          pendingCount: pendingCount,
          totalCount: totalCount,
        );
}

class AnswerYES_NO_NOOPINION extends Answer {
  AnswerEnumYES_NO_NOOPINION answer;
  AnswerYES_NO_NOOPINION({
    @required String respondantId,
    int timestamp,
    @required bool pending,
    @required this.answer,
  }) : super(
          respondantId: respondantId,
          timestamp: timestamp,
          pending: pending,
        ) {
    type = AnswerType.YES_NO_NOOPINION;
  }

  static AnswerYES_NO_NOOPINION fromMap(Map map) {
    return AnswerYES_NO_NOOPINION(
        respondantId: map[Answer.RESPONDANT_ID_FEILD],
        pending: map[Answer.PENDING_FEILD],
        timestamp: map[Answer.TIMESTAMP_FEILD],
        answer: answerEnumFromString(map[Answer.ANSWER_FEILD]));
  }

  static AnswerEnumYES_NO_NOOPINION answerEnumFromString(String str) {
    return AnswerEnumYES_NO_NOOPINION.values
        .firstWhere((e) => e.toString() == str);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      Answer.PENDING_FEILD: this.pending,
      Answer.RESPONDANT_ID_FEILD: this.respondantId,
      Answer.TIMESTAMP_FEILD: timestamp,
      Answer.ANSWER_FEILD: answer.toString(),
      Answer.ANSWER_TYPE_FEILD: AnswerType.YES_NO_NOOPINION.toString()
    };
  }

  static Stream<PollSummary> generateSummaryStream(
      Stream<List<Answer>> answerListStream) {
    return answerListStream.map((map) => generateSummary(map));
  }

  static PollSummary generateSummary(List<Answer> answerList) {
    int yesCount = 0;
    int noCount = 0;
    int noOpinionCount = 0;
    int pendingCount = 0;
    int totalCount = 0;
    for (AnswerYES_NO_NOOPINION i in answerList) {
      totalCount++;
      if (i.pending) {
        pendingCount++;
      } else {
        if (i.answer == AnswerEnumYES_NO_NOOPINION.YES) {
          yesCount++;
        } else if (i.answer == AnswerEnumYES_NO_NOOPINION.NO) {
          noCount++;
        } else {
          noOpinionCount++;
        }
      }
    }
    return PollSummaryYES_NO_NOOPINION(
        yesCount: yesCount,
        noCount: noCount,
        noOpinionCount: noOpinionCount,
        pendingCount: pendingCount,
        totalCount: totalCount);
  }
}
