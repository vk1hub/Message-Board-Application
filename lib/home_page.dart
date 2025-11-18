import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> messageBoards = [
    {
      'name': 'General Discussion',
      'icon': Icons.chat,
      'color': Colors.blue,
    },
    {
      'name': 'Technology',
      'icon': Icons.computer,
      'color': Colors.blue,
    },
    {
      'name': 'Sports',
      'icon': Icons.sports_basketball,
      'color': Colors.orange,
    },
    {
      'name': 'Music',
      'icon': Icons.headphones_rounded,
      'color': Colors.purple,
    },
    {
      'name': 'Movies',
      'icon': Icons.movie,
      'color': Colors.red,
    },
    {
      'name': 'Gaming',
      'icon': Icons.games,
      'color': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Boards'),
      ),
      body: ListView.builder(
        itemCount: messageBoards.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: messageBoards[index]['color'],
                child: Icon(
                  messageBoards[index]['icon'],
                  color: Colors.white,
                ),
              ),
              title: Text(
                messageBoards[index]['name'],
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              trailing: Icon(Icons.arrow_forward, size: 16),
            ),
          );
        },
      ),
    );
  }
}