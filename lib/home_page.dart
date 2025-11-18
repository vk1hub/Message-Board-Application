import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String userName = '';

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  void loadUserName() async {
    User? user = auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          userName = '${userDoc['firstName']} ${userDoc['lastName']}';
        });
      }
    }
  }

  final List<Map<String, dynamic>> messageBoards = [
    {'name': 'General Discussion', 'icon': Icons.chat, 'color': Colors.blue},
    {'name': 'Technology', 'icon': Icons.computer, 'color': Colors.blue},
    {'name': 'Sports', 'icon': Icons.sports_basketball, 'color': Colors.blue},
    {'name': 'Music', 'icon': Icons.headphones_rounded, 'color': Colors.blue},
    {'name': 'Movies', 'icon': Icons.movie, 'color': Colors.blue},
    {'name': 'Gaming', 'icon': Icons.games, 'color': Colors.blue},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Message Boards')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.account_circle, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    userName.isNotEmpty ? userName : 'User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    auth.currentUser?.email ?? '',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            // HAMBURGER LIST ITEMS
            ListTile(
              leading: Icon(Icons.message, color: Colors.blue),
              title: Text('Message Boards'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text('Profile'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
                loadUserName();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.blue),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: messageBoards.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: messageBoards[index]['color'],
                child: Icon(messageBoards[index]['icon'], color: Colors.white),
              ),
              title: Text(
                messageBoards[index]['name'],
                style: TextStyle(fontSize: 20),
              ),
              trailing: Icon(Icons.arrow_forward, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      chatRoom: messageBoards[index]['name'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}