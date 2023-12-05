import 'package:flutter/material.dart';
import 'databasehelper.dart';
import 'package:storytime/User.dart';

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
        title: Text('Profile',style:TextStyle(fontSize: 30),),
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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: ${user.firstName} ${user.lastName}',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  'Email: ${user.email}',
                  style: TextStyle(fontSize: 30),
                ),
                // Add more user information as needed
              ],
            ),
          );
        },
      ),
    );
  }
}
