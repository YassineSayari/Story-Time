import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'databasehelper.dart'; // Replace with your actual DatabaseHelper import
import 'User.dart'; // Replace with your actual User import
import 'editprofilepage.dart';
import 'homePage.dart';

class Profile extends StatefulWidget {
  final String userEmail;

  Profile({required this.userEmail});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  late Future<User?> _userFuture;
  late DatabaseHelper _databaseHelper;
  late String _imagePath = 'assets/images/backgroundlogin.jpg';
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper(); // Replace with your actual DatabaseHelper initialization
    _userFuture = _getUserData();
    _loadImagePath(); // Load the user's image path during initialization
  }

  Future<void> _loadImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = prefs.getString('user_image') ?? 'assets/images/backgroundlogin.jpg';
    });
  }

  Future<void> _saveImagePath(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_image', imagePath);
  }

  Future<User?> _getUserData() async {
    try {
      return await _databaseHelper.getUserByEmail(widget.userEmail); // Replace with your actual method to get user data
    } catch (error) {
      print('Error fetching user data: $error');
      return null;
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _saveImagePath(pickedFile.path);
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontSize: 30)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<User?>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.cyan,
                  backgroundColor: Colors.blueGrey,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text('User not found for email: ${widget.userEmail}');
            }

            User user = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.mail),
                              Text(
                                "${widget.userEmail}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          border: Border.all(color: Colors.white, width: 1),
                          image: DecorationImage(
                            image: _imagePath.startsWith('assets')
                                ? AssetImage(_imagePath) as ImageProvider<Object>
                                : FileImage(File(_imagePath)) as ImageProvider<Object>,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(user: user),
                        ),
                      );
                    },
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
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
        currentIndex: 1,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pop(context);
             /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => homePage(
                    userEmail: widget.userEmail,
                    controller: PageController(), // Provide a new PageController instance
                  ),
                ),
              );*/
              break;
            case 1:
              break;
            case 2:
            // Handle My Stories tab click
              break;
          }
        },
      ),
    );
  }
}
