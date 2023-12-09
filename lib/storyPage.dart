import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoryPage extends StatelessWidget {
  final String story;
  final String imageUrl;

  const StoryPage({Key? key, required this.story, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story Page'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                storyImage(imageUrl: imageUrl),
                SizedBox(height: 16),
                // Text from the story
                Text(
                  'Generated Story:\n$story',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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

class storyImage extends StatelessWidget {
  final String imageUrl;

  const storyImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Container(
        width: 150,
        height: 150,
        color: Colors.grey,
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
