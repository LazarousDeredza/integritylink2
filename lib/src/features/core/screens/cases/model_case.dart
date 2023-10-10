import 'package:cloud_firestore/cloud_firestore.dart';

class CaseModel {
  //id
  final String? id;
  final String location;
  final String dateCommitted;
  final String dateReported;
  final String personsInvolved;
  final String supportingEvidence;
  final String reportDetails;
  final String onBehalfOf;
  final String awarenessDetails;
  final String additionalEvidence;
  final String additionalWitnesses;
  final String? reportedBy;
  final List<String>? evidenceUrl;
  final List<Comment>? comments;
  final String? caseID;
  final String? status;
  final String? howItWasResolved;
  final String desiredOutcome;
  final String reportingOutcome;
  final String resolutionDetails;
  final List<String> selectedOffences; // Adding the selected offences list
  final String? witnesses;

  CaseModel(
      {this.id,
      this.evidenceUrl,
      this.status,
      this.howItWasResolved,
      this.caseID,
      this.reportedBy,
      this.witnesses,
      this.comments,
      required this.location,
      required this.dateCommitted,
      required this.dateReported,
      required this.personsInvolved,
      required this.supportingEvidence,
      required this.reportDetails,
      required this.onBehalfOf,
      required this.awarenessDetails,
      required this.additionalEvidence,
      required this.additionalWitnesses,
      required this.desiredOutcome,
      required this.reportingOutcome,
      required this.resolutionDetails,
      required this.selectedOffences});

  //to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'evidenceUrl': evidenceUrl,
        'status': status,
        'caseID': caseID,
        'comments': comments,
        'witnesses': witnesses,
        'reportedBy': reportedBy,
        'howItWasResolved': howItWasResolved,
        'location': location,
        'dateCommitted': dateCommitted,
        'dateReported': dateReported,
        'personsInvolved': personsInvolved,
        'supportingEvidence': supportingEvidence,
        'reportDetails': reportDetails,
        'onBehalfOf': onBehalfOf,
        'awarenessDetails': awarenessDetails,
        'additionalEvidence': additionalEvidence,
        'additionalWitnesses': additionalWitnesses,
        'desiredOutcome': desiredOutcome,
        'reportingOutcome': reportingOutcome,
        'resolutionDetails': resolutionDetails,
        'selectedOffences': selectedOffences
      };

  //from json
  factory CaseModel.fromJson(Map<String, dynamic> json) => CaseModel(
        id: json['id'],
        caseID: json["caseID"],
        witnesses: json["witnesses"],
        evidenceUrl: json['evidenceUrl'],
        comments: json['comments'],
        status: json['status'],
        reportedBy: json['reportedBy'],
        howItWasResolved: json['howItWasResolved'],
        location: json['location'],
        dateCommitted: json['dateCommitted'],
        dateReported: json['dateReported'],
        personsInvolved: json['personsInvolved'],
        supportingEvidence: json['supportingEvidence'],
        reportDetails: json['reportDetails'],
        onBehalfOf: json['onBehalfOf'],
        awarenessDetails: json['awarenessDetails'],
        additionalEvidence: json['additionalEvidence'],
        additionalWitnesses: json['additionalWitnesses'],
        desiredOutcome: json['desiredOutcome'],
        reportingOutcome: json['reportingOutcome'],
        resolutionDetails: json['resolutionDetails'],
        selectedOffences: json['selectedOffences'],
      );

  factory CaseModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CaseModel(
      id: document.id,
      evidenceUrl: data['evidenceUrl'],
      status: data['status'],
      witnesses: data['witnesses'],
      comments: data['comments'],
      caseID: data['caseID'],
      reportedBy: data['reportedBy'],
      howItWasResolved: data['howItWasResolved'],
      location: data['location'],
      dateCommitted: data['dateCommitted'],
      dateReported: data['dateReported'],
      personsInvolved: data['personsInvolved'],
      supportingEvidence: data['supportingEvidence'],
      reportDetails: data['reportDetails'],
      onBehalfOf: data['onBehalfOf'],
      awarenessDetails: data['awarenessDetails'],
      additionalEvidence: data['additionalEvidence'],
      additionalWitnesses: data['additionalWitnesses'],
      desiredOutcome: data['desiredOutcome'],
      reportingOutcome: data['reportingOutcome'],
      resolutionDetails: data['resolutionDetails'],
      selectedOffences: data['selectedOffences'],
    );
  }
}

//create class comment model with the following fields : comment, likes, approved,date

class Comment {
  final String? id;
  final String? comment;
  final int? numberOfLikes;
  final int? numberOfDislikes;

  final String? approved;
  final String? date;
  final String? caseID;
  final String? userID;

  Comment(
      {this.id,
      this.comment,
      this.numberOfLikes,
      this.numberOfDislikes,
      this.approved,
      this.date,
      this.caseID,
      this.userID});

  //to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'comment': comment,
        'numberOfLikes': numberOfLikes,
        'numberOfDislikes': numberOfDislikes,
        'approved': approved,
        'date': date,
        'caseID': caseID,
        'userID': userID,
      };

  //from json
  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'],
        comment: json['comment'],
        numberOfLikes: json['numberOfLikes'],
        numberOfDislikes: json['numberOfDislikes'],
        approved: json['approved'],
        date: json['date'],
        caseID: json['caseID'],
        userID: json['userID'],
      );

  factory Comment.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Comment(
      id: document.id,
      comment: data['comment'],
      numberOfLikes: data['numberOfLikes'],
      numberOfDislikes: data['numberOfDislikes'],
      approved: data['approved'],
      date: data['date'],
      caseID: data['caseID'],
      userID: data['userID'],
    );
  }
}

class LikeAndDislike {
  final String? id;
  final String? caseID;
  final String? userID;
  final String? date;

  LikeAndDislike({this.id, this.caseID, this.userID, this.date});

  //to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'caseID': caseID,
        'userID': userID,
        'date': date,
      };

  //from json
  factory LikeAndDislike.fromJson(Map<String, dynamic> json) => LikeAndDislike(
        id: json['id'],
        caseID: json['caseID'],
        userID: json['userID'],
        date: json['date'],
      );

  factory LikeAndDislike.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return LikeAndDislike(
      id: document.id,
      caseID: data['caseID'],
      userID: data['userID'],
      date: data['date'],
    );
  }
}
