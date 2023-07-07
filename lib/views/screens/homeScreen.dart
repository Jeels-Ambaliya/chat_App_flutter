import 'package:chatapp_flutter/helpers/helper_function_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helpers/firebase_firestore.dart';
import '../../models/resources.dart';
import '../Widgets/tiles_of_group.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream? groups;
  String? groupName;
  TextEditingController gpnameController = TextEditingController();
  final globalkey = GlobalKey<FormState>();

  gettingUserData() async {
    email = await helperFunction.getUserEmail();
    name = await helperFunction.getUserName();

    DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((val) {
      setState(() {
        groups = val;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'searchScreen');
            },
            child: const Icon(
              Icons.search,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, 'entryLoginScreen', (route) => false);
          },
          child: const Icon(Icons.logout_outlined),
        ),
        title: const Text(
          'My Chats',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 30,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: groups,
        builder: (context, snapshot) {
          gettingUserData();

          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length != 0) {
                return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    int reverseIndex =
                        snapshot.data['groups'].length - index - 1;
                    return GroupTile(
                        GroupId: getId(snapshot.data['groups'][reverseIndex]),
                        GroupName:
                            getName(snapshot.data['groups'][reverseIndex]),
                        username: snapshot.data['name']);
                  },
                );
              } else {
                return const Center(
                  child: Icon(
                    Icons.groups,
                    size: 200,
                  ),
                );
              }
            } else {
              return const Center(
                child: Icon(
                  Icons.groups,
                  size: 400,
                ),
              );
            }
          } else {
            return Center(
              child: Icon(
                Icons.groups,
                size: 300,
                color: Colors.grey.shade300,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple.shade700,
        onPressed: () {
          popUpDialog(context);
        },
        label: const Text(
          'Add Friend',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        icon: const Icon(
          Icons.add_box,
          color: Colors.white,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Form(
                key: globalkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Group name',
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
                        controller: gpnameController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please enter group name...';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          groupName = val;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple.shade50)),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade900,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.deepPurple.shade50,
                    ),
                  ),
                  onPressed: () async {
                    if (globalkey.currentState!.validate()) {
                      globalkey.currentState!.save();
                      await DatabaseServices(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .cretaingGroup(
                              name!,
                              FirebaseAuth.instance.currentUser!.uid,
                              groupName!);
                      setState(
                        () {
                          gpnameController.clear();
                          groupName = null;
                        },
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'Group Created Successfully',
                        ),
                        backgroundColor: Colors.green,
                      ));
                    }
                  },
                  child: Text(
                    "Create",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade900),
                  ),
                ),
              ],
              title: const Text(
                "Create a Group to chat with your mates",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            );
          },
        );
      },
    );
  }
}
