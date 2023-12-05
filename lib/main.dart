import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});


  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StoryTime',
      home: Login(controller: controller),
    );
  }
}

class SavedStory {
  final int id;
  final String topic;
  final String story;

  SavedStory({required this.id, required this.topic, required this.story});
}