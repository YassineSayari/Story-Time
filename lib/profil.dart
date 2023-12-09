import 'package:flutter/material.dart';
import 'databasehelper.dart';
import 'package:storytime/User.dart';
import 'editprofilepage.dart';

class Profile extends StatefulWidget {
  final String userEmail;

  Profile({required this.userEmail});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = DatabaseHelper.instance.getUserByEmail(widget.userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontSize: 30)),
        centerTitle: true,
      ),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Text('User not found');
          }

          User user = snapshot.data!;
          return Container(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: 350,
                      height: 200,
                      margin: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: TextStyle(fontSize: 45, color: Colors.white),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.mail),
                              Text(
                                "${user.email}",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        border: Border.all(color: Colors.white, width: 1),
                        //Image
                        image: DecorationImage(
                          image: AssetImage('assets/images/backgroundlogin.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
            SizedBox(
              width: 300,
              height: 55,
                child:ElevatedButton(
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
                      fontSize: 30,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ),
              ],
            ),
          );
        },
      ),
    );
  }
}
