import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/features/core/screens/group_chat/pages/chat_page.dart';
import 'package:integritylink/src/features/core/screens/institutions/inst_model.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  final _db = FirebaseFirestore.instance;

  // saving the userdata
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "name": fullName,
      "email": email,
      "groups": [],
      "image": "",
      "id": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // creating a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${id}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // search
  // searchByName(String groupName) {
  //   return groupCollection.where("groupName", arrayContains: groupName).get();
  // }

  searchByName(String groupName) {
    String searchTerm = groupName.toLowerCase();
    return groupCollection
        .where('groupName', isGreaterThanOrEqualTo: searchTerm)
        .where('groupName', isLessThanOrEqualTo: searchTerm + '\uf8ff')
        .get();
  }

  Future<QuerySnapshot> listOfGrps() {
    return groupCollection.orderBy('groupName').get();
  }

  Future<List<InstModel>> listOfSchools() async {
    final snapshot = await _db.collection("institutions").get();
    final userData =
        snapshot.docs.map((e) => InstModel.fromSnapshot(e)).toList();
    return userData;
    //return groupCollection.orderBy('schoolName').get();
  }

  // function -> bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupExit(
      String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      Get.snackbar("Join Failed", "You are already in this club",
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar("Successfully joined $groupName", "",
          backgroundColor: Colors.green[100],
          snackPosition: SnackPosition.BOTTOM);

      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });

      Future.delayed(const Duration(seconds: 2), () {
        Get.to(
          () => ChatPage(
            groupId: groupId,
            groupName: groupName,
            userName: userName,
          ),
        );
      });
    }
  }

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  Future<void> createSchool(InstModel school) async {
    await _db.collection("institutions").add(school.toJson()).then((value) {
      print("School added");
      // Show snack bar
      Get.snackbar("Success", "School added successfully",
          snackPosition: SnackPosition.BOTTOM);
    }).catchError((error) {
      print("Error adding school: $error");
      // Show error snack bar
      Get.snackbar("Error", "Failed to add school",
          snackPosition: SnackPosition.BOTTOM);
    });
  }
}
