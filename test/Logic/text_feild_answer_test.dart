import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/text_feild_answer.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/poll.dart';
import 'package:blueberrypoll/Logic/user.dart';
import 'package:test/test.dart';

void main() {
  List<AnswerTEXT_FEILD> answerListOne;
  List<AnswerTEXT_FEILD> answerListTwo;
  UserP respondant;
  setUp(() {
    respondant = UserP("my id");
    answerListOne = [
      AnswerTEXT_FEILD(
          respondant: respondant, answer: "yo", timestamp: 1, pending: false),
      AnswerTEXT_FEILD(
          respondant: respondant,
          answer: "yofrf",
          timestamp: 1,
          pending: false),
      AnswerTEXT_FEILD(
          respondant: respondant,
          answer: "diginign",
          timestamp: 1,
          pending: false),
      AnswerTEXT_FEILD(
          respondant: respondant,
          answer: "jkdhkjfhksd",
          timestamp: 1,
          pending: true),
      AnswerTEXT_FEILD(
          respondant: respondant,
          answer: "jkdhfkjdfhkdjhf",
          timestamp: 1,
          pending: true),
      AnswerTEXT_FEILD(
          respondant: respondant,
          answer: "kdfjklsdfhkjdfh",
          timestamp: 1,
          pending: true),
    ];

    answerListTwo = [
      AnswerTEXT_FEILD(
          respondant: respondant,
          answer: "djkfhkjdhfjkds",
          timestamp: 1,
          pending: false),
      AnswerTEXT_FEILD(
          respondant: respondant,
          answer: "lkdfhkjdfhkdf",
          timestamp: 1,
          pending: false),
      AnswerTEXT_FEILD(
          respondant: respondant,
          answer: "kjdhfkjdsfhkjfdshf",
          timestamp: 1,
          pending: false),
      AnswerTEXT_FEILD(
          respondant: respondant,
          answer: "dkjhfkjdfhkjdshf",
          timestamp: 1,
          pending: true),
      AnswerTEXT_FEILD(
          respondant: respondant,
          answer: "kjdfhkjdfhkjdsfh",
          timestamp: 1,
          pending: true),
    ];
  });

  test("should create a correct poll summary", () {
    PollSummaryTEXT_FEILD summary =
        AnswerTEXT_FEILD.generateSummary(answerListOne);
    expect(summary.answeredCount, 3);
    expect(summary.pendingCount, 3);
    summary = AnswerTEXT_FEILD.generateSummary(answerListTwo);
    expect(summary.answeredCount, 3);
    expect(summary.pendingCount, 2);
  });

  test("should remap a stream of answer lists to a stream of poll summarys",
      () {
    int counter = 0;
    StreamController<List<AnswerTEXT_FEILD>> answerListStream =
        StreamController();
    Stream<PollSummaryTEXT_FEILD> summaryStream =
        AnswerTEXT_FEILD.generateSummaryStream(answerListStream.stream);
    summaryStream.listen((PollSummaryTEXT_FEILD summary) {
      print("fired");
      if (counter == 0) {
        expect(summary.answeredCount, 3);
        expect(summary.pendingCount, 3);
      } else if (counter == 1) {
        // test("Second item of stream", () {
        expect(summary.answeredCount, 3);
        expect(summary.pendingCount, 2);
        // });
      }

      counter++;
    });
    answerListStream.sink.add(answerListOne);
    answerListStream.sink.add(answerListTwo);
  });
}
