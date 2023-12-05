import 'package:flutter/material.dart';
import 'main.dart';
import 'story.dart';

class SavedStoriesPage extends StatelessWidget {
  final List<SavedStory> savedStories;

  const SavedStoriesPage({Key? key, required this.savedStories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Stories',style: TextStyle(fontSize: 30)),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: savedStories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(savedStories[index].topic, style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
              textAlign: TextAlign.center,),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Story(topic:savedStories[index].topic,story: savedStories[index].story),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

