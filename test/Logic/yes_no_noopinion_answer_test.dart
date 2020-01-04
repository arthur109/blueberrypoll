import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/yes_no_noopinion_answer.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:test/test.dart';

void main() {
  List<AnswerYES_NO_NOOPINION> answerListOne;
  List<AnswerYES_NO_NOOPINION> answerListTwo;
  User respondant;
  setUp(() {
    respondant = User("my id");
    answerListOne = [
      AnswerYES_NO_NOOPINION(
          respondant: respondant,
          answer: AnswerEnumYES_NO_NOOPINION.NO,
          timestamp: 1,
          pending: false),
      AnswerYES_NO_NOOPINION(
          respondant: respondant,
          answer: AnswerEnumYES_NO_NOOPINION.YES,
          timestamp: 1,
          pending: false),
      AnswerYES_NO_NOOPINION(
          respondant: respondant,
          answer: AnswerEnumYES_NO_NOOPINION.YES,
          timestamp: 1,
          pending: false),
      AnswerYES_NO_NOOPINION(
          respondant: respondant,
          answer: AnswerEnumYES_NO_NOOPINION.NOOPINION,
          timestamp: 1,
          pending: false),
      AnswerYES_NO_NOOPINION(
          respondant: respondant,
          answer: AnswerEnumYES_NO_NOOPINION.NOOPINION,
          timestamp: 1,
          pending: true),
      AnswerYES_NO_NOOPINION(
          respondant: respondant,
          answer: AnswerEnumYES_NO_NOOPINION.NO,
          timestamp: 1,
          pending: true),
      AnswerYES_NO_NOOPINION(
          respondant: respondant,
          answer: AnswerEnumYES_NO_NOOPINION.NO,
          timestamp: 1,
          pending: true),
      AnswerYES_NO_NOOPINION(
          respondant: respondant,
          answer: AnswerEnumYES_NO_NOOPINION.NO,
          timestamp: 1,
          pending: true),
    ];

    answerListTwo = [
      AnswerYES_NO_NOOPINION(
          respondant: respondant,
          answer: AnswerEnumYES_NO_NOOPINION.YES,
          timestamp: 1,
          pending: false),
      AnswerYES_NO_NOOPINION(
          respondant: respondant,
          answer: AnswerEnumYES_NO_NOOPINION.NO,
          timestamp: 1,
          pending: false),
      AnswerYES_NO_NOOPINION(
          respondant: respondant,
          answer: AnswerEnumYES_NO_NOOPINION.NOOPINION,
          timestamp: 1,
          pending: false),
      AnswerYES_NO_NOOPINION(
          respondant: respondant,
          answer: AnswerEnumYES_NO_NOOPINION.NOOPINION,
          timestamp: 1,
          pending: false),
      AnswerYES_NO_NOOPINION(
          respondant: respondant,
          answer: AnswerEnumYES_NO_NOOPINION.NO,
          timestamp: 1,
          pending: false),
      AnswerYES_NO_NOOPINION(
          respondant: respondant,
          answer: AnswerEnumYES_NO_NOOPINION.NO,
          timestamp: 1,
          pending: true),
      AnswerYES_NO_NOOPINION(
          respondant: respondant,
          answer: AnswerEnumYES_NO_NOOPINION.NO,
          timestamp: 1,
          pending: true),
    ];
  });

  test("should create a correct poll summary", () {
    PollSummaryYES_NO_NOOPINION summary =
        AnswerYES_NO_NOOPINION.generateSummary(answerListOne);
    expect(summary.yesCount, 2);
    expect(summary.noCount, 1);
    expect(summary.noOpinionCount, 1);
    expect(summary.pendingCount, 4);
    summary = AnswerYES_NO_NOOPINION.generateSummary(answerListTwo);
    expect(summary.yesCount, 1);
    expect(summary.noCount, 2);
    expect(summary.noOpinionCount, 2);
    expect(summary.pendingCount, 2);
  });

  test("should remap a stream of answer lists to a stream of poll summarys",
      () {
    int counter = 0;
    StreamController<List<AnswerYES_NO_NOOPINION>> answerListStream =
        StreamController();
    Stream<PollSummaryYES_NO_NOOPINION> summaryStream =
        AnswerYES_NO_NOOPINION.generateSummaryStream(answerListStream.stream);
    summaryStream.listen((PollSummaryYES_NO_NOOPINION summary) {
      print("fired");
      if (counter == 0) {
        // test("First item of stream", () {
        expect(summary.yesCount, 2);
        expect(summary.noCount, 1);
        expect(summary.noOpinionCount, 1);
        expect(summary.pendingCount, 4);
        // });
      } else if (counter == 1) {
        // test("Second item of stream", () {
        expect(summary.yesCount, 1);
        expect(summary.noCount, 2);
        expect(summary.noOpinionCount, 2);
        expect(summary.pendingCount, 2);
        // });
      }

      counter++;
    });
    answerListStream.sink.add(answerListOne);
    answerListStream.sink.add(answerListTwo);
  });
}
