import 'package:badminton_app/ColorList.dart';
import 'package:badminton_app/Routes/welcome_page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseUser _loggedInUser;
final _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;

class LiveChat extends StatefulWidget {
  static String id = 'live_chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<LiveChat> {
  final messageTextController = TextEditingController();

  String _messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        _loggedInUser = user;
        print(_loggedInUser.email);
      } else {
        Navigator.pop(context);
        Navigator.pushNamed(context, WelcomePage.id);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Live Chat'),
        backgroundColor: backgroundColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(firestore: _firestore),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Container(
                decoration:  BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: blackShade, offset: Offset(8, 8), blurRadius: 12),
                    BoxShadow(color: whiteShade, offset: Offset(-8, -8), blurRadius: 12),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        cursorColor: backgroundColor,
                        controller: messageTextController,
                        onChanged: (value) {
                          //Do something with the user input.
                          _messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        if(_messageText != null && _messageText != '') {
                          int value = await checkCounter();
                          _firestore.collection("live_messages").add({
                            "sender": kName,
                            "text": _messageText,
                            "textNumber": value,
                            "dateTime": DateTime.now().toString(),
                          });
                          updateCounter(value);
                          //final currentUser = _loggedInUser.email;


                          print('Updated');
                          setState(() {
                            messageTextController.clear();
                            _messageText = '';
                          });
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: blueIconColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<int> checkCounter() async {
  var value;
  await _firestore
      .collection('Counter')
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((f) {
      print('${f.data}');
      value = f.data['counter'];
    });
  });
  print('Chekc Counter -> Counter = $value');
  return value;
}

void updateCounter(int value) {
  try {
    _firestore
        .collection('Counter')
        .document('1')
        .updateData({'counter': ++value});
  } catch (e) {
    print(e.toString());
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({
    Key key,
    @required Firestore firestore,
  })  : _firestore = firestore,
        super(key: key);

  final Firestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("live_messages")
          .orderBy("textNumber", descending: true).snapshots(),//arranging messages based on text number
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: backgroundColor,
            ),
          );
        }
        final messages = snapshot.data.documents;
        print(messages);
        print(messages.length);
        for (var i=0;i<messages.length;i++) {
          print('$i = ${messages[i].data['textNumber']}');
        }
        List<MessageBubble> messageBubbles = <MessageBubble>[];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final dateTime = message.data['dateTime'];
          final currentUser = kName;

          final messageBubble = MessageBubble(
            messageText: messageText,
            messageSender: messageSender,
            isme: currentUser == messageSender,
            time: dateTime,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    @required this.messageText,
    @required this.messageSender,
    @required this.isme,
    @required this.time,
  });

  final messageText;
  final messageSender;
  final bool isme;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: (isme)? EdgeInsets.fromLTRB(70, 0, 10, 0):EdgeInsets.fromLTRB(10, 0, 70, 0),
            child: Container(
              decoration: BoxDecoration(
//                color: isme ? textColor : backgroundColor,
                color: backgroundColor,
                borderRadius: isme
                    ? BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                )
                    : BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                boxShadow: [
                  BoxShadow(color: blackShade, offset: Offset(2, 2), blurRadius: 2),
                  BoxShadow(color: whiteShade, offset: Offset(-2, -2), blurRadius: 2),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10,5, 10, 5),
                    child: !isme ? Text(
                      '$messageSender',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black54,
                      ),
                    ):Text('You',
                      style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black54,
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      '$messageText',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text((time == null)?'Date':time.substring(0,11),
                          style: TextStyle(
                            color: Colors.black26,
                          ),
                        ),
                        Text((time == null)?'Time':time.substring(11,16),
                        style: TextStyle(
                          color: Colors.black26,
                        ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
