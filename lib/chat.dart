import 'dart:ui';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flash_chat/constants.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

// final _firestore = FirebaseFirestore.instance;
// User loggedinuser;

class ChatScreen extends StatefulWidget {
  static const String id = 'Chat_Screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  String messageText;

  //final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser() {
    try {
    //  final user = _auth.currentUser;
     // if (user != null) {
      //  loggedinuser = user;
     //   print(loggedinuser.email);
     // }
    } catch (e) {
      print(e);
    }
  }

  // void getmessages()async{
  //  final messege= await _firestore.collection('messages').get();
  //  for(var messege in messege.docs)
  //  print(messege.data());
  // }

  // void getmessagesStream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var messege in snapshot.docs) {
  //       print(messege.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
              //  _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            streamMessages(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        hintText: 'Type your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      // messageTextController.clear();
                      // _firestore.collection('messages').add({
                      //   'text': messageText,
                      //   'sender': loggedinuser.email,
                      // });
                    },
                    child: Text(
                      'Send',
                      style:  TextStyle(
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
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

class messagestyle extends StatelessWidget {
  messagestyle({this.text, this.sender, this.itsme});

  final String text;
  final String sender;
  bool itsme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
        itsme ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            sender,
            style: TextStyle(
                color: itsme ? Colors.black87 : Colors.greenAccent,
                fontSize: 10),
          ),
          Material(
            color: itsme ? Colors.lightBlueAccent : Colors.greenAccent,
            borderRadius: itsme
                ? BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))
                : BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                topLeft: Radius.circular(30)),
            elevation: 4.0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                '$text',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class streamMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder
    //<QuerySnapshot>
      (
        //stream: _firestore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages = snapshot.data.docs.reversed;
          List<messagestyle> messageslist = [];
          for (var message in messages) {
            final textmessages = message.data()['text'];
            final sendermessages = message.data()['sender'];
            // final currentuser = loggedinuser.email;

            final messagesWidget = messagestyle(
              sender: sendermessages,
              text: textmessages,
              //itsme: currentuser == sendermessages,
            );

            messageslist.add(messagesWidget);
          }
          return Expanded(
            child:
            ListView(
                reverse: true,
                padding: EdgeInsets.all(10), children: messageslist),
          );
        });
  }
}
