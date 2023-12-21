import 'package:flutter/material.dart';
import 'authentication_helper.dart';
import 'login.dart';
import 'databasehelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homePage.dart';

class Subscribe extends StatefulWidget {
  const Subscribe({Key? key, required this.controller}) : super(key: key);
  final PageController controller;

  @override
  State<Subscribe> createState() => SubscribeState();
}

class SubscribeState extends State<Subscribe> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController mail = TextEditingController();
  final TextEditingController prenom = TextEditingController();
  final TextEditingController nom = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordconf = TextEditingController();

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  Future<UserCredential?> signInWithGoogle() async {
    UserCredential? userCredential = await AuthenticationHelper.signInWithGoogle();

    if (userCredential != null) {
      String userEmail = userCredential.user?.email ?? "";
      print("signed Up with email: $userEmail");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => homePage(controller: widget.controller, userEmail: userEmail),
        ),
      );
    }
  }

  bool log = false;
  bool mdp = false;

  void verifier() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail.text,
        password: password.text,
      );

      if (userCredential.user != null && password.text == passwordconf.text) {
        log = true;
        mdp = true;

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'email': mail.text,
          'firstName': prenom.text,
          'lastName': nom.text,
          'password': password.text,
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login(controller: widget.controller)),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle registration errors
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('Error: ${e.message}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/backgroundlogin.jpg",
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: prenom,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 27,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            labelStyle: TextStyle(
                              color: Color(0xFF7743DB),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: nom,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 27,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            labelStyle: TextStyle(
                              color: Color(0xFF7743DB),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: mail,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 27,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Color(0xFF7743DB),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: password,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          style: TextStyle(
                            color: Color(0xFF7743DB),
                            fontSize: 27,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Color(0xFF755DC1),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: passwordconf,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          style: TextStyle(
                            color: Color(0xFF7743DB),
                            fontSize: 27,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Confirm your Password',
                            labelStyle: TextStyle(
                              color: Color(0xFF755DC1),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                verifier();
                                if (log && mdp) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Login(controller: widget.controller)),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9F7BFF),
                            ),
                            child: Text(
                              'Subscribe',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              UserCredential? userCredential = await signInWithGoogle();

                              if (userCredential != null) {
                                String userEmail = userCredential.user?.email ?? "";
                                print("signed Up with email: $userEmail");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/google_sign_in.png',
                                  height: 60,
                                  width: 264,
                                ),
                                SizedBox(width: 16),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Login(controller: widget.controller)),
                                );
                              },
                              child: const Text(
                                'Login !',
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
