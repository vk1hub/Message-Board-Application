import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final String chatRoom;

  ChatPage({required this.chatRoom});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final messageController = TextEditingController();
  String userName = '';

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  void getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      setState(() {
        userName = '${userDoc['firstName']} ${userDoc['lastName']}';
      });
    }
  }

  void sendMessage() async {
    if (messageController.text.isEmpty) {
      return;
    }

    await FirebaseFirestore.instance.collection('messages').add({
      'boardName': widget.chatRoom,
      'message': messageController.text,
      'username': userName,
      'timestamp': DateTime.now(),
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoom),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('boardName', isEqualTo: widget.chatRoom)
                  .snapshots(),

              builder: (context, snapshot) {

                // showing loading circle if no data to prevent error
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;

                // Sort messages by timestamp so newest is at bottom
                messages.sort((a, b) {
                  Timestamp timeA = a['timestamp'];
                  Timestamp timeB = b['timestamp'];
                  return timeA.compareTo(timeB);
                });

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[messages.length - 1 - index];
                    Timestamp timestamp = message['timestamp'];
                    DateTime time = timestamp.toDate();
                    
                    // formatting the date/time string
                    String minutes = time.minute < 10 ? '0${time.minute}' : '${time.minute}';
                    String timeString = '${time.month}/${time.day} ${time.hour}:$minutes';
                    
                    return Card(
                      margin: EdgeInsets.all(6),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  message['username'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  timeString,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(message['message']),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}