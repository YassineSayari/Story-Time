import 'package:flutter/material.dart';
import 'databasehelper.dart';
import 'package:storytime/User.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  EditProfilePage({required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
    _oldPasswordController.text ="";
  }

  void verifyAndUpdateProfile() async {
    if (_oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      // Show an error message if any of the fields are empty
      _showAlertDialog("All fields must be filled.");
      return;
    }

    // Check if the old password matches the password in the database
    if (_oldPasswordController.text == widget.user.password) {
      // Check if the new password matches the confirmation of the new password
      if (_newPasswordController.text == _confirmPasswordController.text) {
        // Update user profile if verification passes
        User updatedUser = User(
          id: widget.user.id,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          password: _newPasswordController.text,
        );

        await DatabaseHelper.instance.updateUser(updatedUser);
        Navigator.pop(context);
        _showAlertDialogS("Updated successfully");
      } else {
        // Show an error message or handle the case where passwords don't match
        _showAlertDialog("New password and confirmation do not match.");
      }
    } else {
      // Show an error message or handle the case where old password is incorrect
      _showAlertDialog("Old password is incorrect.");
    }

  }


  void _showAlertDialogS(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(fontSize: 30)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                      fontSize: 15.0,
                      color: Color(0xffA9A9A9),
                      fontWeight: FontWeight.w500),
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                      fontSize: 15.0,
                      color: Color(0xffA9A9A9),
                      fontWeight: FontWeight.w500),
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                enabled: false,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                      fontSize: 15.0,
                      color: Color(0xffA9A9A9),
                      fontWeight: FontWeight.w500),
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _oldPasswordController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Old Password',
                  hintStyle: const TextStyle(
                      fontSize: 15.0,
                      color: Color(0xffA9A9A9),
                      fontWeight: FontWeight.w500),
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true, // Mask the new password
                decoration: InputDecoration(
                  labelText: 'Enter New Password',
                  hintStyle: const TextStyle(
                      fontSize: 15.0,
                      color: Color(0xffA9A9A9),
                      fontWeight: FontWeight.w500),
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true, // Mask the confirm password
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  hintStyle: const TextStyle(
                      fontSize: 15.0,
                      color: Color(0xffA9A9A9),
                      fontWeight: FontWeight.w500),
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: verifyAndUpdateProfile,
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20), // Added space for better layout
            ],
          ),
        ),
      ),
    );
  }
}
