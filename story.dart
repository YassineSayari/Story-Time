import 'package:flutter/material.dart';
import 'main.dart';

class Story extends StatelessWidget {
  final String story;
  final String topic;

  const Story({Key? key,required this.topic, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            Text('$topic:\n',style:TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.bold,
            ),),
            Text(
              '$story',
              style: TextStyle(
                fontSize: 22,

              ),
            ),
          ],
        ),
      ),
    );
  }
}
