import 'package:flutter/material.dart';
import 'package:comp414/utils/functions.dart';
import 'package:crypt/crypt.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool hidePass = true;
  bool hidePass2 = true;
  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    // CollectionReference users = FirebaseFirestore.instance.collection('users');

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
                    children: const[
                      Icon(Icons.enhanced_encryption_outlined, color: Colors.purple, size: 125,),
                      Text("Register and start PassPorting now!", style: TextStyle(

                        fontSize: 31,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,),

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
                    child:Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: password,
                            obscureText: hidePass,
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
                        IconButton(
                            onPressed: () {
                              setState(() {
                                hidePass = !hidePass;
                              });
                            },
                            icon: hidePass ? const Icon(Icons.remove_red_eye_outlined) : const Icon(Icons.visibility_off_outlined)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: password2,
                            obscureText: hidePass2,
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
                        IconButton(
                            onPressed: () {
                              setState(() {
                                hidePass2 = !hidePass2;
                              });
                            },
                            icon: hidePass ? const Icon(Icons.remove_red_eye_outlined) : const Icon(Icons.visibility_off_outlined)),
                      ],
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
                              (username.text.length <= 32 &&
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
                              //print(E);
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
