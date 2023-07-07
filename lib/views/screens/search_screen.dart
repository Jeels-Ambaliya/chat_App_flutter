import 'package:chatapp_flutter/helpers/helper_function_class.dart';
import 'package:chatapp_flutter/views/screens/chapScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helpers/firebase_firestore.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  QuerySnapshot? searchSnapshot;
  bool hasSearchedUser = false;
  String userName = '';
  User? user;
  bool isJoined = false;

  @override
  void initState() {
    getCurrentUserIdAndName();
    super.initState();
  }

  getCurrentUserIdAndName() async {
    await helperFunction.getUserName().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange.shade300,
        title: const Text(
          'Search ',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 16,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search group',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.bold),
                          contentPadding: EdgeInsets.all(25),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Icon(
                              Icons.person,
                              size: 25,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          fillColor: Colors.grey.shade200,
                          focusColor: Colors.grey.shade200,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                        controller: searchController,
                        onChanged: (val) async {
                          if (searchController.text.isNotEmpty) {
                            DatabaseServices()
                                .searchGroupbyName(searchController.text)
                                .then((val) {
                              setState(() {
                                searchSnapshot = val;
                                hasSearchedUser = true;
                              });
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search_rounded,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: (hasSearchedUser)
                ? ListView.builder(
                    itemCount: searchSnapshot!.docs.length,
                    itemBuilder: (context, index) {
                      return gpTile(
                        userName,
                        searchSnapshot!.docs[index]['groupId'],
                        searchSnapshot!.docs[index]['groupName'],
                        searchSnapshot!.docs[index]['admin'],
                      );
                    },
                  )
                : Container(
                    child: Center(
                      child: Icon(
                        Icons.search_rounded,
                        size: 400,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  JoinedOrNot(String groupId, String groupName, String username, String admin) {
    DatabaseServices(uid: user!.uid)
        .isUserJoined(groupName, groupId, username)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget gpTile(
      String userName, String groupId, String groupName, String admin) {
    JoinedOrNot(groupId, groupName, userName, admin);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.orange.shade100,
        elevation: 3,
        child: ListTile(
          isThreeLine: true,
          title: Text(
            groupName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 30,
                width: 70,
                child: ElevatedButton(
                  onPressed: () async {
                    await DatabaseServices(uid: user!.uid)
                        .toggle(groupId, userName, groupName);
                    if (isJoined) {
                      isJoined = !isJoined;
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatScreen(
                            GroupId: groupId,
                            GroupName: groupName,
                            username: userName),
                      ));
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      (isJoined) ? Colors.grey : Colors.amber.shade700,
                    ),
                  ),
                  child: Text(
                    (isJoined) ? 'Joined' : 'Join',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Join for Conversation with Samarth Movaliya',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              Text('ID :${groupId}'),
            ],
          ),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.amber,
            child: Text(
              groupName.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
