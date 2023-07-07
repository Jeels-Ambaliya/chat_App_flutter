import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helpers/firebase_firestore.dart';

class GroupInfoScreen extends StatefulWidget {
  final String admin;
  final String GroupName;
  final String GroupId;

  const GroupInfoScreen(
      {Key? key,
      required this.GroupId,
      required this.GroupName,
      required this.admin})
      : super(key: key);

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  @override
  Stream? members;

  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.GroupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.deepPurple.shade200,
        centerTitle: true,
        title: const Text(
          'Group Info',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color: Colors.deepPurple.shade100,
                elevation: 8,
                child: ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.deepPurple.shade700,
                    child: Text(
                      widget.GroupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  title: Text(
                    'Group : ${widget.GroupName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 25,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Admin : ${widget.admin.split("_")[1]}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: StreamBuilder(
              stream: members,
              builder: (context, snapshot) {
                getMembers();
                if (snapshot.hasData) {
                  if (snapshot.data['members'] != null) {
                    if (snapshot.data['members'].length != 0) {
                      return ListView.builder(
                        itemCount: snapshot.data['members'].length,
                        itemBuilder: (context, index) {
                          int reverseIndex =
                              snapshot.data['members'].length - index - 1;
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Card(
                              color: Colors.orange.shade50,
                              elevation: 2,
                              child: ListTile(
                                isThreeLine: true,
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.amber.shade500,
                                  child: Text(
                                    snapshot.data['members'][index]
                                        .toString()
                                        .split('_')[1][0]
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  snapshot.data['members'][index]
                                      .toString()
                                      .split('_')[1],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 25,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'ID : ${snapshot.data['members'][index].toString().split("_")[0]}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'NO MEMBERS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: Text(
                        'NO MEMBERS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurple.shade700,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
