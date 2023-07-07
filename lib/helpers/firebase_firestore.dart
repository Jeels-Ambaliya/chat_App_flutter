import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final String? uid;

  DatabaseServices({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  Future updateUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      'name': fullName,
      'email': email,
      'groups': [],
      'uid': uid,
    });
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  cretaingGroup(String username, String id, String groupname) async {
    DocumentReference documentReference = await groupCollection.add({
      'groupName': groupname,
      'groupIcon': "",
      'admin': '${id}_$username',
      'members': [],
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': '',
    });

    documentReference.update({
      'members': FieldValue.arrayUnion(["${uid}_$username"]),
      'groupId': documentReference.id,
    });

    DocumentReference userDocumentReferencs = userCollection.doc(uid);
    return userDocumentReferencs.update({
      'groups': FieldValue.arrayUnion(["${documentReference.id}_$groupname"])
    });
  }

  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference documentReference = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot['admin'];
  }

  getGroupMembers(String groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  searchGroupbyName(String groupName) {
    return groupCollection.where('groupName', isEqualTo: groupName).get();
  }

  Future<bool> isUserJoined(
      String groupName, String groupId, String username) async {
    DocumentReference userDocument = userCollection.doc(uid);
    DocumentSnapshot userSnapshot = await userDocument.get();
    List<dynamic> groups = await userSnapshot['groups'];
    if (groups.contains('${groupId}_$groupName')) {
      return true;
    } else {
      return false;
    }
  }

  Future toggle(String groupId, String username, String groupName) async {
    DocumentReference docref = userCollection.doc(uid);
    DocumentReference groupref = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await docref.get();
    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains('${groupId}_$groupName')) {
      await docref.update({
        'groups': FieldValue.arrayRemove(['${groupId}_$groupName']),
      });
      await groupref.update({
        'members': FieldValue.arrayRemove(['${uid}_$username']),
      });
    } else {
      await docref.update({
        'groups': FieldValue.arrayUnion(['${groupId}_$groupName']),
      });
      await groupref.update({
        'members': FieldValue.arrayUnion(['${uid}_$username']),
      });
    }
  }

  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection('messages').add(chatMessageData);
    groupCollection.doc(groupId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }
}
