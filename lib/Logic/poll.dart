import 'dart:async';
import 'package:blueberrypoll/Data/database_interface.dart';
import 'package:blueberrypoll/Logic/answer.dart';
import 'package:blueberrypoll/Logic/star_rating_answer.dart';
import 'package:blueberrypoll/Logic/text_feild_answer.dart';
import 'package:blueberrypoll/Logic/yes_no_answer.dart';
import 'package:blueberrypoll/Logic/yes_no_noopinion_answer.dart';
import 'package:firebase/firebase.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/streams.dart';

class PollSnapshot {
  String id;
  String question;
  AnswerType answerType;
  bool isAnonymous;
  bool isHidden;
  int timestamp;
  String creatorId;
  bool isActive;
  List<Answer> answers;
  bool areResultsVisible;

  PollSnapshot({
    this.id,
    @required this.question,
    @required this.answerType,
    @required this.isAnonymous,
    this.timestamp,
    @required this.creatorId,
    this.answers,
    this.isActive = false,
    this.areResultsVisible = false,
    this.isHidden = false,
  }) {
    if (this.timestamp == null) {
      this.timestamp = DateTime.now().millisecondsSinceEpoch;
    }
    if (this.answers == null) {
      this.answers = List<Answer>();
    }
  }

  List<Map<String, dynamic>> answerListToMap(List<Answer> answers) {
    List<Map<String, dynamic>> temp = List<Map<String, dynamic>>();
    for (Answer i in answers) {
      temp.add(i.toMap());
    }
    return temp;
  }

  Map<String, dynamic> toMap() {
    return {
      Poll.CREATOR_ID_KEY: this.creatorId,
      Poll.TIMESTAMP_KEY: this.timestamp,
      Poll.QUESTION_KEY: this.question,
      Poll.IS_ANONYMOUS_KEY: this.isAnonymous,
      Poll.ANSWER_TYPE_KEY: this.answerType.toString(),
      Poll.ANSWERS_KEY: this.answerListToMap(this.answers),
      Poll.ARE_RESULTS_VISIBLE_KEY: this.areResultsVisible,
      Poll.IS_HIDDEN_KEY: this.isHidden
      // Poll.IS_ACTIVE_KEY: this.isActive
    };
  }
}

class Poll {
  static const String QUESTION_KEY = "question";
  static const String ANSWER_TYPE_KEY = "answer type";
  static const String IS_ANONYMOUS_KEY = "is anonymous";
  static const String IS_HIDDEN_KEY = "is hidden";

  static const String TIMESTAMP_KEY = "timestamp";
  static const String CREATOR_ID_KEY = "creator id";
  static const String ANSWERS_KEY = "answers";
  static const String ARE_RESULTS_VISIBLE_KEY = "are results visible";
  static const String IS_ACTIVE_KEY = "is active";

  static const String NO_ANSWER_CODE = "no answer found";

  DatabaseInterface database;
  Stream<PollSnapshot> allInfoStream;
  String id;
  String question;
  AnswerType answerType;
  bool isAnonymous;
  bool isHidden;
  int timestamp;
  String creatorId;
  Stream<List<Answer>> answers;
  Stream<dynamic> areResultsVisible;

  Poll({@required this.id, @required this.database}) {
    print("is active initialized");


    Stream<PollSnapshot> tempAllInfoStream = this
        .database
        .entryPoint
        .child(DatabaseInterface.POLLS_NODE +"/" + this.id)
        .onValue
        .map((QueryEvent data) {
      Map pollMap = data.snapshot.val();
      return PollSnapshot(
          id: this.id,
          question: pollMap[Poll.QUESTION_KEY],
          answerType: Poll.answerTypeFromString(pollMap[Poll.ANSWER_TYPE_KEY]),
          isAnonymous: pollMap[Poll.IS_ANONYMOUS_KEY],
          timestamp: pollMap[Poll.TIMESTAMP_KEY],
          creatorId: pollMap[Poll.CREATOR_ID_KEY],
          isHidden: pollMap[Poll.IS_HIDDEN_KEY],
          answers:
              Poll.answerMapListToAnswerObjectList(pollMap[Poll.ANSWERS_KEY]),
          areResultsVisible: pollMap[Poll.ARE_RESULTS_VISIBLE_KEY],
          isActive: null);
    });

    this.allInfoStream = CombineLatestStream.combine2(tempAllInfoStream, this.isActiveStream(), (PollSnapshot snapshot, isActive){
      snapshot.isActive = isActive;
      return snapshot;
    });

    print("all info stream initialized");

    this.answers = fetchStreamFeild(Poll.ANSWERS_KEY).map((data) {
      return Poll.answerMapListToAnswerObjectList(data.snapshot.val());
    });

    print("answer stream initialized");
    this.areResultsVisible =
        fetchStreamFeild(Poll.ARE_RESULTS_VISIBLE_KEY).map((QueryEvent data) {
      return data.snapshot.val() as bool;
    });

    print("result visibilty stream initialized");
    
  }

  Future<PollSnapshot> getSnapshot() async {

    Map pollMap = (await this.database.entryPoint.child(DatabaseInterface.POLLS_NODE +"/" + this.id).once("value")).snapshot.val();

    return PollSnapshot(
          id: this.id,
          question: pollMap[Poll.QUESTION_KEY],
          answerType: Poll.answerTypeFromString(pollMap[Poll.ANSWER_TYPE_KEY]),
          isAnonymous: pollMap[Poll.IS_ANONYMOUS_KEY],
          timestamp: pollMap[Poll.TIMESTAMP_KEY],
          creatorId: pollMap[Poll.CREATOR_ID_KEY],
          isHidden: pollMap[Poll.IS_HIDDEN_KEY],
          answers:
              Poll.answerMapListToAnswerObjectList(pollMap[Poll.ANSWERS_KEY]),
          areResultsVisible: pollMap[Poll.ARE_RESULTS_VISIBLE_KEY],
          isActive: null);
  }

  Stream<bool> isActiveStream(){
    return database.getActivePollId().map((data){return (data == this.id);});
  }

  Stream<QueryEvent> fetchStreamFeild(String feild) {
    return this
        .database
        .entryPoint
        .child(DatabaseInterface.POLLS_NODE + "/" + this.id + "/" + feild)
        .onValue;
  }

  Future<void> initializeConstantData() async {
    this.question = await fetchConstantFeild(Poll.QUESTION_KEY);
    this.answerType = Poll.answerTypeFromString(
        await fetchConstantFeild(Poll.ANSWER_TYPE_KEY));
    this.isAnonymous = await fetchConstantFeild(Poll.IS_ANONYMOUS_KEY);
    this.timestamp = await fetchConstantFeild(Poll.TIMESTAMP_KEY);
    this.creatorId = await fetchConstantFeild(Poll.CREATOR_ID_KEY);
    this.isHidden = await fetchConstantFeild(Poll.IS_HIDDEN_KEY);
  }

  Future<dynamic> fetchConstantFeild(String feild) async {
    return (await this
            .database
            .entryPoint
            .child(DatabaseInterface.POLLS_NODE + "/" + this.id + "/" + feild)
            .once("value"))
        .snapshot
        .val();
  }

  static List<Answer> answerMapListToAnswerObjectList(Map answers) {
    List<Answer> temp = new List();
    if(answers == null){
      return temp;
    }
    for (String key in answers.keys) {
      Map i = answers[key];
      temp.add(answerFromMap(i));
    }
    return temp;
  }

  static Answer answerFromMap(Map i) {
    String answerType = i[Answer.ANSWER_TYPE_FEILD];
    if (answerType == AnswerType.YES_NO_NOOPINION.toString()) {
      return AnswerYES_NO_NOOPINION.fromMap(i);
    } else if (answerType == AnswerType.YES_NO.toString()) {
      return AnswerYES_NO.fromMap(i);
    } else if (answerType == AnswerType.STAR_RATING.toString()) {
      return AnswerSTAR_RATING.fromMap(i);
    } else if (answerType == AnswerType.TEXT_FEILD.toString()) {
      return AnswerTEXT_FEILD.fromMap(i);
    }
  }

  static AnswerType answerTypeFromString(String str) {
    return AnswerType.values.firstWhere((e) => e.toString() == str);
  }

  Stream<PollSummary> getSummaryStream(String userId) {
    if (this.answerType == AnswerType.YES_NO_NOOPINION) {
      return configureSummaryStream(
          userId, AnswerYES_NO_NOOPINION.generateSummaryStream(answers));
    } else if (this.answerType == AnswerType.YES_NO) {
      return configureSummaryStream(
          userId, AnswerYES_NO.generateSummaryStream(answers));
    } else if (this.answerType == AnswerType.STAR_RATING) {
      return configureSummaryStream(
          userId, AnswerSTAR_RATING.generateSummaryStream(answers));
    } else if (this.answerType == AnswerType.TEXT_FEILD) {
      print("text feild type");
      return configureSummaryStream(
          userId, AnswerTEXT_FEILD.generateSummaryStream(answers));
    }
  }

  Stream<PollSummary> configureSummaryStream(
      String userId, Stream<PollSummary> stream) {
    Function configureSummaryPermissions = (PollSummary summary) {
      if (this.creatorId == userId) {
        summary.hasResultVisibilityPrivilege = true;
      } else {
        summary.hasResultVisibilityPrivilege = false;
      }
      summary.isAnonymous = this.isAnonymous;
      summary.parentPoll = this;
      return summary;
    };

    return CombineLatestStream.combine3(
        stream.map(configureSummaryPermissions), this.areResultsVisible, this.isActiveStream(),
        (pollSummary, areResultsVisible, isActive) {
      pollSummary.areResultsVisible = areResultsVisible;
      pollSummary.isActive = isActive;
      return pollSummary;
    });
  }

  Future<bool> areTheirAnswers()async{
    return (await this.database.entryPoint.child(this.answersPath()).once("value")).snapshot.exists();
      }

  Stream getAnswerOfUser(String userId) {
    return this.answers.map((List answers){
      for(Answer i in answers){
        // print(i.toMap());
        if(i.respondantId == userId){
          return i;
        }
      }
      print("did not find matching answer");
      return Poll.NO_ANSWER_CODE;
    });
    // return (this
    //         .database
    //         .entryPoint
    //         .child(DatabaseInterface.POLLS_NODE +
    //             "/" +
    //             id +
    //             "/" +
    //             Poll.ANSWERS_KEY)
    //         .orderByChild(Answer.RESPONDANT_ID_FEILD)
    //         .equalTo(userId)
    //         .onChildAdded)
    //     .map((QueryEvent query) {
    //   if (query.snapshot.hasChildren()) {
    //     // print(query.snapshot.val());
        
    //     return answerFromMap(query.snapshot.val());
    //   }
    //   return null;
    // });
  }

  Future<void> submitAnswer(Answer answer) async {
    return await this.database.entryPoint.child(answersPath()+"/"+answer.respondantId).set(answer.toMap());
  }

  Future<void> clearAnswers() async {
    return await this.database.entryPoint.child(answersPath()).set({});
  }

  String answersPath(){
    return DatabaseInterface.POLLS_NODE+"/"+this.id+"/"+Poll.ANSWERS_KEY;
  }

  bool isCreator(String userId) {
    return userId == this.creatorId;
  }

  Future<void> setResultVisibility(bool visibility) async {
    await database.entryPoint
        .child(DatabaseInterface.POLLS_NODE +
            "/" +
            id +
            "/" +
            Poll.ARE_RESULTS_VISIBLE_KEY)
        .set(visibility);
  }

  Future<void> setHiddenState(bool visibility) async {
    await database.entryPoint
        .child(DatabaseInterface.POLLS_NODE +
            "/" +
            id +
            "/" +
            Poll.IS_HIDDEN_KEY)
        .set(visibility);
  }

  Future<void> setAsActive(){
    database.setActivePollId(this.id);
  }

}
