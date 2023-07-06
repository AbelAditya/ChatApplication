import 'package:chat_app/Screens/Welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/component/ChatBubble.dart';

class ChatScreen extends StatefulWidget {
  static String id = "chat";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User currentUser;

  void getCurrrentUser() async {
    final user = await _auth.currentUser;
    if (user != null) {
      currentUser = user;
      // print(currentUser.email);
    }
  }

  void dispose(){
    super.dispose();
    msgcontroller.dispose();
  }

  TextEditingController msgcontroller = TextEditingController();

  void initState() {
    super.initState();
    getCurrrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushReplacementNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("Messages").orderBy("Time",descending: true).snapshots(),
              builder: (context, snapshot) {
                List<chatBubble> texts = [];
                if (!snapshot.hasData) {
                  CircularProgressIndicator();
                } else {
                  final msgs = snapshot.data?.docs;

                  for (var x in msgs!) {
                    var v = x.data() as Map;
                    if(v["Sender"]==currentUser.email) {
                      texts.add(
                        chatBubble(sender: v["Sender"], text: v["Text"],isMe: true,),);
                    }
                    else texts.add(
                      chatBubble(sender: v["Sender"], text: v["Text"],isMe: false,),);
                  }
                }

                // print(chats);
                return Expanded(
                  child: ListView(
                    reverse: true,
                    children: texts,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgcontroller,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _firestore
                          .collection("Messages")
                          .add({"Sender": currentUser.email, "Text": msgcontroller.text, "Time": DateTime.now()});
                      msgcontroller.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}