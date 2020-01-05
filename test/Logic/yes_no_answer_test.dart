import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/yes_no_answer.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:test/test.dart';

void main() {
  List<AnswerYES_NO> answerListOne;
  List<AnswerYES_NO> answerListTwo;
  UserP respondant;
  setUp(() {
    respondant = UserP("my id");
    answerListOne = [
      AnswerYES_NO(
          respondantId: "yo",
          answer: AnswerEnumYES_NO.NO,
          timestamp: 1,
          pending: false),
      AnswerYES_NO(
          respondantId: "yo",
          answer: AnswerEnumYES_NO.YES,
          timestamp: 1,
          pending: false),
      AnswerYES_NO(
          respondantId: "yo",
          answer: AnswerEnumYES_NO.YES,
          timestamp: 1,
          pending: false),
      AnswerYES_NO(
          respondantId: "yo",
          answer: AnswerEnumYES_NO.NO,
          timestamp: 1,
          pending: true),
      AnswerYES_NO(
          respondantId: "yo",
          answer: AnswerEnumYES_NO.NO,
          timestamp: 1,
          pending: true),
      AnswerYES_NO(
          respondantId: "yo",
          answer: AnswerEnumYES_NO.NO,
          timestamp: 1,
          pending: true),
    ];

    answerListTwo = [
      AnswerYES_NO(
          respondantId: "yo",
          answer: AnswerEnumYES_NO.YES,
          timestamp: 1,
          pending: false),
      AnswerYES_NO(
          respondantId: "yo",
          answer: AnswerEnumYES_NO.NO,
          timestamp: 1,
          pending: false),
      AnswerYES_NO(
          respondantId: "yo",
          answer: AnswerEnumYES_NO.NO,
          timestamp: 1,
          pending: false),
      AnswerYES_NO(
          respondantId: "yo",
          answer: AnswerEnumYES_NO.NO,
          timestamp: 1,
          pending: true),
      AnswerYES_NO(
          respondantId: "yo",
          answer: AnswerEnumYES_NO.NO,
          timestamp: 1,
          pending: true),
    ];
  });

  test("should create a correct poll summary", () {
    PollSummaryYES_NO summary = AnswerYES_NO.generateSummary(answerListOne);
    expect(summary.yesCount, 2);
    expect(summary.noCount, 1);
    expect(summary.pendingCount, 3);
    summary = AnswerYES_NO.generateSummary(answerListTwo);
    expect(summary.yesCount, 1);
    expect(summary.noCount, 2);
    expect(summary.pendingCount, 2);
  });

  test("should remap a stream of answer lists to a stream of poll summarys",
      () {
    int counter = 0;
    StreamController<List<AnswerYES_NO>> answerListStream = StreamController();
    Stream<PollSummaryYES_NO> summaryStream =
        AnswerYES_NO.generateSummaryStream(answerListStream.stream);
    summaryStream.listen((PollSummaryYES_NO summary) {
      print("fired");
      if (counter == 0) {
          expect(summary.yesCount, 2);
          expect(summary.noCount, 1);
          expect(summary.pendingCount, 3);
      } else if (counter == 1) {
        // test("Second item of stream", () {
          expect(summary.yesCount, 1);
          expect(summary.noCount, 2);
          expect(summary.pendingCount, 2);
        // });
      }

      counter++;
    });
    answerListStream.sink.add(answerListOne);
    answerListStream.sink.add(answerListTwo);
  });
}
