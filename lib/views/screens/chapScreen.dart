import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helpers/firebase_firestore.dart';
import '../Widgets/message_tile.dart';
import 'group_info_page.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  final String GroupName;
  final String GroupId;

  const ChatScreen(
      {Key? key,
      required this.GroupId,
      required this.GroupName,
      required this.username})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot>? myChats;
  String admin = '';
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getChatandAdmin();
  }

  getChatandAdmin() {
    DatabaseServices().getChats(widget.GroupId).then((val) {
      setState(() {
        myChats = val;
      });
    });
    DatabaseServices().getGroupAdmin(widget.GroupId).then((value) {
      setState(() {
        admin = value;
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
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GroupInfoScreen(
                    GroupId: widget.GroupId,
                    GroupName: widget.GroupName,
                    admin: admin,
                  ),
                ),
              );
            },
            child: const Icon(Icons.info_outline),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
        title: Text(
          widget.GroupName,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: myChats,
            builder: (context, AsyncSnapshot snapshot) {
              getChatandAdmin();
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Messagetile(
                        Message: snapshot.data.docs[index]['message'],
                        Sender: snapshot.data.docs[index]["sender"],
                        SendbyMe: widget.username ==
                            snapshot.data.docs[index]['sender']);
                  },
                );
              } else {
                return Container();
              }
            },
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              color: Colors.grey.shade700,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Send a Message",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (messageController.text.isNotEmpty) {
                        Map<String, dynamic> chatMessages = {
                          'message': messageController.text,
                          'sender': widget.username,
                          'time': DateTime.now().millisecondsSinceEpoch,
                        };
                        DatabaseServices()
                            .sendMessage(widget.GroupId, chatMessages);
                      }
                      setState(() {
                        messageController.clear();
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue.shade700,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
