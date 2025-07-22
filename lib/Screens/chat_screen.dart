import 'package:flutter/material.dart';
import 'package:flashchat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
User loggedInUser = _auth.currentUser!;
class ChatScreen extends StatefulWidget {
  static String id = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  String messageText ="";
  final TextEditingController txtCtlr = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } on FirebaseAuthException catch (e){
      print(e.message);
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () {
                //getMessagesStream();
                 _auth.signOut();
                 Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Color(0xFFF5F5F5),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(firestore: _firestore),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: txtCtlr,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _firestore.collection('messages').add({
                        'text' : messageText,
                        'sender' : loggedInUser.email,
                        'timestamp' : FieldValue.serverTimestamp(),
                      });
                      txtCtlr.clear();
                    },
                    child: Icon(Icons.send,color: Colors.blueAccent,size: 25,),
                    // child: Text(
                    //   'Send',
                    //   style: kSendButtonTextStyle,
                    // ),
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

class MessagesStream extends StatelessWidget {
  const MessagesStream({
    super.key,
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
            final messages = snapshot.data!.docs.reversed;
            List<MessageBubble> messageBubbles = [];
            for(var message in messages){
              final data = message.data() as Map<String, dynamic>;
              final messageText = data['text'];
              final sender = data['sender'];
              final msgTime = data['timestamp'] as Timestamp?;

              String timeString = '';
              if (msgTime != null) {
                DateTime dateTime = msgTime.toDate();
                timeString = DateFormat('h:mm a').format(dateTime); // e.g. 3:45 PM
              }
              final currentUser = loggedInUser.email;

              final messageBubble = MessageBubble(
                  messageText: messageText,
                  sender: sender,
                  isMe: currentUser == sender,
                  time: timeString,
              );

              messageBubbles.add(messageBubble);
            }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              children: messageBubbles,
            ),
          );
        },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.messageText,
    required this.sender,
    required this.isMe,
    required this.time,
  });

  final dynamic messageText;
  final dynamic sender;
  final bool isMe;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
              sender,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12
              ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(topLeft:isMe ? Radius.circular(30): Radius.zero,bottomLeft:Radius.circular(30),bottomRight: Radius.circular(30),topRight: isMe ? Radius.zero :Radius.circular(30)),
            color: isMe ? Colors.blueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Text(
                  messageText,
                  style: TextStyle(fontSize: 15,color: isMe ? Colors.white : Colors.black),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6,vertical: 8),
            child: Text(
                time,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 10
              ),
            ),
          ),
        ],
      ),
    );
  }
}
