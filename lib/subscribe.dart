import 'package:flutter/material.dart';
import 'login.dart';
import 'User.dart';
import 'databasehelper.dart';

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


  bool log = false;
  bool mdp = false;

  void verifier() {

    if (mail.text.contains("@") && password.text == passwordconf.text) {
      log = true;
      mdp = true;

      User u = User(
        firstName: prenom.text,
        lastName: nom.text,
        email: mail.text,
        password: password.text,
      );
      databaseHelper.insertUser(u);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: prenom,
                          keyboardType: TextInputType.text,

                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 27,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
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
                            color: Color(0xFFFFFFFF),
                            fontSize: 27,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
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
                            color: Color(0xFFFFFFFF),
                            fontSize: 27,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
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
                          decoration: const InputDecoration(
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
                          decoration: const InputDecoration(
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
                          width: 300,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                verifier();
                                if (log && mdp) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Login(controller:widget.controller)),
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
                        SizedBox(
                          height: 15,
                        ),


                        Row(
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontFamily: 'Poppins',

                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  Login(controller: widget.controller)),
                                );
                              },
                              child: const Text(
                                'Login !',
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 23,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
