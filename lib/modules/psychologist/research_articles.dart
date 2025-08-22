import 'package:flutter/material.dart';

class ResearchArticlesScreen extends StatelessWidget {
  final List<Map<String, String>> articles = [
    {
      'title': 'Improving Social Interaction',
      'summary': 'New AI-based interaction techniques for autistic kids.'
    },
    {
      'title': 'Cognitive Therapy Advances',
      'summary': 'Research on visual learning and behavior.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Research & Techniques")),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.article, color: Colors.deepPurple),
            title: Text(articles[index]['title']!),
            subtitle: Text(articles[index]['summary']!),
            onTap: () {
              // Open article or PDF
            },
          );
        },
      ),
    );
  }
}
