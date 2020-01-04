import 'dart:async';

import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:meta/meta.dart';

class PollSnapshot {
  String id;
  String question;
  AnswerType answerType;
  bool isAnonymous;
  int timestamp;
  String creatorId;
  List<Answer> answers;
  bool areResultsVisible;

  PollSnapshot({
    @required this.id,
    @required this.question,
    @required this.answerType,
    @required this.isAnonymous,
    @required this.timestamp,
    @required this.creatorId,
    this.answers,
    @required this.areResultsVisible,
  });
}


class Poll{
      DatabaseInterface database;
			Stream<PollSnapshot> allInfoStream;
			String id;
			String question;
			AnswerType answerType;
			bool isAnonymous;
			int timestamp;
			String creatorId;
			Stream<List<Answer>> answers;
			Stream<bool> areResultsVisible;
			Stream<bool> isActive;
				
      Poll({
        @required this.id,
        @required this.database
      });

      // Stream<PollSummary> getSummaryStream(User user) // stream is hooked up to areResults visible stream, and will push new object if it changes
			// Stream<bool> getAnswerOfUser(User user) // returns null if no answer 
			// bool isCreator(User user)
			// Future<void> setResultVisibility(bool visibility)

}

