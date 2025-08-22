import 'package:flutter/material.dart';

class RewardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("🎉 Celebration Wall")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, size: 100, color: Colors.amber),
            SizedBox(height: 20),
            Text("Great Job!", style: TextStyle(fontSize: 28)),
            SizedBox(height: 10),
            Text("You completed today's tasks!", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
