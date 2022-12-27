import 'package:flutter/material.dart';
import 'package:comp414/utils/functions.dart';
import 'package:crypt/crypt.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
        ),
        body: CustomScrollView(
          //avoid render problems
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        child: //Image.asset("src/logo_1.png"), insert logo maybe
                            const Text("PM"),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      /*
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(RegExp(r'^\d+(\d+)?$')),
                      ], */
                      controller: nameSurname,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        hintText: 'Name Surname',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      /*
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(RegExp(r'^\d+(\d+)?$')),
                      ], */
                      controller: username,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        hintText: 'E Mail',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        hintText: 'Password',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: password2,
                      obscureText: true,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        hintText: 'Password Confirm',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          //REPLACE THIS IN THE FUTURE
                          if ((username.text.isNotEmpty &&
                                  password.text.isNotEmpty &&
                                  password2.text.isNotEmpty) &&
                              (username.text.length <= 16 &&
                                  username.text.length >= 5) &&
                              (password.text.length <= 24 &&
                                  password.text.length >= 8) &&
                              (password.text == password2.text)) {
                            try {
                              //try to register
                              var appleInBytes = utf8.encode(password.text);
                              String value = sha256.convert(appleInBytes).toString();
                              String value2 = Crypt.sha256(password.text, salt: 'abcdefghijklmnop').toString();

                              if (await register(username.text, value2)) {
                                createUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    nameSurname.text,
                                    username.text,
                                    value2);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(successBar);
                                Navigator.pop(context);
                              } else {
                                //on fail register
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(failBar);
                              }
                            } catch (E) {
                              print(E);
                              //on timeout
                              /*ScaffoldMessenger.of(context)
                                  .showSnackBar(failBar);*/
                              //print(E);
                            }
                          } else {
                            if(!(username.text.isNotEmpty &&
                                password.text.isNotEmpty &&
                                password2.text.isNotEmpty)) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(wrongBar);
                            } else if (!(password.text == password2.text)) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(passDiffBar);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(wrongBar);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            //backgroundColor: const Color(0xFFB68A33),
                            ),
                        child: const Text('Register'),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

TextEditingController username = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController password2 = TextEditingController();
TextEditingController nameSurname = TextEditingController();

const failBar = SnackBar(
  content: Text(
    'This mail has already been used.',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.red,
);

const wrongBar = SnackBar(
  content: Text(
    'Please make sure all fields are filled correctly.',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.red,
);

const passDiffBar = SnackBar(
  content: Text(
    'Please make sure passwords are same.',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.red,
);

const successBar = SnackBar(
  content: Text(
    'Your account has been successfully created!',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.green,
);
