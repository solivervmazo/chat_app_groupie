import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  final String? uid;
  DbService({
    this.uid,
  });

  //reference for colelctions
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  //update db user
  Future updateUser({
    required String fullName,
    required String email,
  }) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  //update db user
  Future getUser({
    required String email,
  }) async {
    QuerySnapshot snapshot = await userCollection
        .where(
          "email",
          isEqualTo: email,
        )
        .get();
    return snapshot;
  }

  //get user groups
  Future getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  //create group
  Future createGroup({
    required String userName,
    required String uid,
    required String groupName,
  }) async {
    DocumentReference documentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${uid}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    await documentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": documentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${documentReference.id}_$groupName"]),
    });
  }

  //get chat
  Future getChats({required String groupId}) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  //get chat
  Future getGroupAdmin({required String groupId}) async {
    DocumentReference doc = groupCollection.doc(groupId);
    DocumentSnapshot snapshot = await doc.get();
    return snapshot["admin"];
  }

  //get members
  Future getGroupMembers({required String groupId}) async {
    return groupCollection.doc(groupId).snapshots();
  }

  //search group by name

  Future searchGroupByName({required String groupName}) async {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  Future<bool> isUserJoined({
    required String groupName,
    required String groupId,
    required String fullName,
  }) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

// join/exit join
  Future toggleGroupJoin({
    required String fullName,
    required String groupId,
    required String groupName,
  }) async {
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
        "members": FieldValue.arrayRemove(["${uid}_$fullName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$fullName"])
      });
    }
  }

  //chat
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
