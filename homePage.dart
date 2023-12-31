import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'storyPage.dart';
import 'main.dart';
import 'savedStories.dart';
import 'profil.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key, required this.controller, required this.userEmail}) : super(key: key);
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

  List<String> imageCarouselUrls = [
    'assets/images/layla.jpeg',
    'assets/images/boy.jpeg',
    'assets/images/parent.jpeg',
    'assets/images/lamb.jpeg',
    'assets/images/parent2.jpeg',
    'assets/images/hboy.jpeg',
    'assets/images/cat.jpeg',
    'assets/images/parent3.jpeg',
  ];

  int currentPage = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (currentPage < imageCarouselUrls.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      widget.controller.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> generateStory(String topic) async {
    print('Generating story...');
    final apiKey = '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';
    final textEndpoint = 'https://api.openai.com/v1/engines/text-davinci-003/completions';
    final unsplashEndpoint = 'https://api.unsplash.com/photos/random';
    final unsplashAccessKey = 'hYIAb65E5FOFs_t2SyLqm6YBgd2vGXfv9hUfD_dujzI';

    final prompt = 'Generate a short story for children about $topic.Make it 4 short paragraphs and Provide a happy ending';


    final textResponse = await http.post(
      Uri.parse(textEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'prompt': prompt,
        'max_tokens': 300,
      }),
    );

    if (textResponse.statusCode == 200) {
      final textData = jsonDecode(textResponse.body);
      setState(() {
        generatedStory = textData['choices'][0]['text'];
      });

      saveStory(topic, generatedStory);

      final unsplashResponse = await http.get(
        Uri.parse('$unsplashEndpoint?query=$topic as a child firenly image'),
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

      }
    } else {
      print('Error generating story: ${textResponse.reasonPhrase}');

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

  Widget listeDesImages() {
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: PageView.builder(
            controller: widget.controller,
            itemCount: imageCarouselUrls.length,
            itemBuilder: (context, index) {
              return MyImage(imageUrl: imageCarouselUrls[index]);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Story Time',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(controller: widget.controller)));
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30),
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
              SizedBox(height: 20),
              listeDesImages(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'My Stories',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          switch (index) {
            case 0:

              break;
            case 1:

              Navigator.push(
                context,
                MaterialPageRoute(
                      builder: (context) => Profile(userEmail: widget.userEmail),
          ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedStoriesPage(savedStories: savedStories),
                ),
              );
              break;
          }
               },
      ),
    );
  }
}

class MyImage extends StatelessWidget {
  final String imageUrl;

  const MyImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.asset(
        imageUrl,
        width: 150,
        height: 350,
        fit: BoxFit.cover,
      ),
    );
  }
}