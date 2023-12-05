import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'storyPage.dart';
import 'main.dart';
import 'savedStories.dart';
import 'profil.dart';
import 'package:storytime/User.dart';
import 'databasehelper.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key, required this.controller,required this.userEmail}) : super(key: key);
  final PageController controller;
  final String userEmail;

  @override
  State<homePage> createState() => homePageState();
}

class homePageState extends State<homePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController topic = TextEditingController();
  String generatedStory = '';
  String generatedImageUrl = '';

  List<SavedStory> savedStories = [];


  Future<void> generateStory(String topic) async {
    print('Generating story...');
    final apiKey = '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';
    final textEndpoint = 'https://api.openai.com/v1/engines/text-davinci-003/completions';
    final unsplashEndpoint = 'https://api.unsplash.com/photos/random';
    final unsplashAccessKey = 'hYIAb65E5FOFs_t2SyLqm6YBgd2vGXfv9hUfD_dujzI'; // Replace with your Unsplash Access Key

    final prompt = 'Generate a short story for children about $topic.';


    final textResponse = await http.post(
      Uri.parse(textEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'prompt': prompt,
        'max_tokens': 200,
      }),
    );

    if (textResponse.statusCode == 200) {
      final textData = jsonDecode(textResponse.body);
      setState(() {
        generatedStory = textData['choices'][0]['text'];
      });

      saveStory(topic, generatedStory);

      final unsplashResponse = await http.get(
        Uri.parse('$unsplashEndpoint?query=$topic as a cartoon character'),
        headers: {'Authorization': 'Client-ID $unsplashAccessKey'},
      );

      if (unsplashResponse.statusCode == 200) {
        final unsplashData = jsonDecode(unsplashResponse.body);
        setState(() {
          generatedImageUrl = unsplashData['urls']['regular'];
        });


        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryPage(story: generatedStory, imageUrl: generatedImageUrl),
          ),
        );
      } else {
        print('Error generating image: ${unsplashResponse.reasonPhrase}');
        // Handle error appropriately
      }
    } else {
      print('Error generating story: ${textResponse.reasonPhrase}');
      // Handle error appropriately
    }
  }


  bool valide = false;
  void verifier() {
    if (topic.text.isEmpty) {
      valide = true;
    }
  }


  void saveStory(String topic, String generatedStory) {
    setState(() {
      savedStories.add(SavedStory(
        id: savedStories.length + 1,
        topic: topic,
        story: generatedStory,
      ));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page',style:TextStyle(fontSize: 30),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Handle home item click
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profile(userEmail:widget.userEmail), // Create UserProfilePage class
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedStoriesPage(savedStories: savedStories),
                ),
              );
            },
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: topic,
                decoration: const InputDecoration(
                  labelText: 'Enter your story topic',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 3,
                      color: Colors.black45,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 3,
                      color: Colors.black,
                    ),
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a story topic';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 300,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    print("button pressed");
                    generateStory(topic.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9F7BFF),
                  ),
                  child: Text(
                    'Generate Story',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
