import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';

import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  print('-- main');
  WidgetsFlutterBinding.ensureInitialized();
  print('-- WidgetsFlutterBinding.ensureInitialized');

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDRjcOG-UtA5pPXXMqm1zz6mtLqU3IXlaM',
      appId: '1:82081837207:android:9dda6b3d277c2a99bcb9d2',
      messagingSenderId: '82081837207',
      projectId: 'story-time-f39d7',
    ),
  );


  print('-- main: Firebase.initializeApp');
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
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