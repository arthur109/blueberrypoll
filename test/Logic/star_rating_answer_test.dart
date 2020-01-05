import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:blueberrypoll/Logic/star_rating_answer.dart';
import 'package:test/test.dart';

void main() {
  List<AnswerSTAR_RATING> answerListOne;
  List<AnswerSTAR_RATING> answerListTwo;
  setUp((){
    answerListOne = [
      AnswerSTAR_RATING(
          respondantId: "yo",
          answer: AnswerEnumSTAR_RATING.ONE,
          timestamp: 1,
          pending: false),
      AnswerSTAR_RATING(
          respondantId: "yo",
          answer: AnswerEnumSTAR_RATING.TWO,
          timestamp: 1,
          pending: false),
      AnswerSTAR_RATING(
          respondantId: "yo",
          answer: AnswerEnumSTAR_RATING.THREE,
          timestamp: 1,
          pending: false),
      AnswerSTAR_RATING(
          respondantId: "yo",
          answer: AnswerEnumSTAR_RATING.FOUR,
          timestamp: 1,
          pending: false),
      AnswerSTAR_RATING(
          respondantId: "yo",
          answer: AnswerEnumSTAR_RATING.FIVE,
          timestamp: 1,
          pending: true),
      AnswerSTAR_RATING(
          respondantId: "yo",
          answer: AnswerEnumSTAR_RATING.ONE,
          timestamp: 1,
          pending: true),
      AnswerSTAR_RATING(
          respondantId: "yo",
          answer: AnswerEnumSTAR_RATING.TWO,
          timestamp: 1,
          pending: true),
      AnswerSTAR_RATING(
          respondantId: "yo",
          answer: AnswerEnumSTAR_RATING.THREE,
          timestamp: 1,
          pending: true),
    ];

    answerListTwo = [
      AnswerSTAR_RATING(
          respondantId: "yo",
          answer: AnswerEnumSTAR_RATING.ONE,
          timestamp: 1,
          pending: false),
      AnswerSTAR_RATING(
          respondantId: "yo",
          answer: AnswerEnumSTAR_RATING.ONE,
          timestamp: 1,
          pending: false),
      AnswerSTAR_RATING(
          respondantId: "yo",
          answer: AnswerEnumSTAR_RATING.FIVE,
          timestamp: 1,
          pending: false),
      AnswerSTAR_RATING(
          respondantId: "yo",
          answer: AnswerEnumSTAR_RATING.THREE,
          timestamp: 1,
          pending: false),
      AnswerSTAR_RATING(
          respondantId: "yo",
          answer: AnswerEnumSTAR_RATING.THREE,
          timestamp: 1,
          pending: false),
      AnswerSTAR_RATING(
          respondantId: "yo",
          answer: AnswerEnumSTAR_RATING.THREE,
          timestamp: 1,
          pending: true),
      AnswerSTAR_RATING(
          respondantId: "yo",
          answer: AnswerEnumSTAR_RATING.THREE,
          timestamp: 1,
          pending: true),
    ];
  });

  test("should create a correct poll summary", () {
    PollSummarySTAR_RATING summary =
        AnswerSTAR_RATING.generateSummary(answerListOne);
    expect(summary.oneCount, 1);
    expect(summary.twoCount, 1);
    expect(summary.threeCount, 1);
    expect(summary.fourCount, 1);
    expect(summary.fiveCount, 0);
    expect(summary.pendingCount, 4);
    summary = AnswerSTAR_RATING.generateSummary(answerListTwo);
    expect(summary.oneCount, 2);
    expect(summary.twoCount, 0);
    expect(summary.threeCount, 2);
    expect(summary.fourCount, 0);
    expect(summary.fiveCount, 1);
    expect(summary.pendingCount, 2);
  });

  test("should remap a stream of answer lists to a stream of poll summarys",
      () {
    int counter = 0;
    StreamController<List<AnswerSTAR_RATING>> answerListStream =
        StreamController();
    Stream<PollSummarySTAR_RATING> summaryStream =
        AnswerSTAR_RATING.generateSummaryStream(answerListStream.stream);
    summaryStream.listen((PollSummarySTAR_RATING summary) {
      print("fired");
      if (counter == 0) {
        expect(summary.oneCount, 1);
        expect(summary.twoCount, 1);
        expect(summary.threeCount, 1);
        expect(summary.fourCount, 1);
        expect(summary.fiveCount, 0);
        expect(summary.pendingCount, 4);
      } else if (counter == 1) {
        expect(summary.oneCount, 2);
        expect(summary.twoCount, 0);
        expect(summary.threeCount, 2);
        expect(summary.fourCount, 0);
        expect(summary.fiveCount, 1);
        expect(summary.pendingCount, 2);
      }

      counter++;
    });
    answerListStream.sink.add(answerListOne);
    answerListStream.sink.add(answerListTwo);
  });
}
