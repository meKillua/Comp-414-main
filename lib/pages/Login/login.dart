

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comp414/utils/functions.dart';
import 'package:crypt/crypt.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home/home.dart';

class Login extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(""),
              backgroundColor: Colors.purple,
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.login)),
                Tab(icon: Icon(Icons.create)),
              ],
            ),

          ),
          body:TabBarView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 500,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: Colors.purple),
                        borderRadius: BorderRadius.all(
                            Radius.circular(
                                15.0),
                          //                 <--- border radius here
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "E-mail",hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.purple,
                          style: TextStyle(color: Colors.purple),

                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 500,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: Colors.purple),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                              15.0),
                          //                 <--- border radius here
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Password",hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.purple,
                          style: TextStyle(color: Colors.purple),
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,

                        ),
                      ),
                    ),
                  ),
                 Padding(padding: EdgeInsets.only(right: 8),
                 child: Align(
                   alignment: Alignment.centerRight,
                   child: ElevatedButton(
                       child: Text('Sign-In'),
                       style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                       onPressed: ()  async {
                         String value2 = Crypt.sha256(_passwordController.text, salt: 'abcdefghijklmnop').toString();
                         if(await signIn(_emailController.text, value2)){
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) =>  Home()),
                           );
                         }

                       }
                   ),
                 ) ,
                 )

                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 500,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: Colors.purple),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                              15.0),
                          //                 <--- border radius here
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: "Name Surname",hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.purple,
                          style: TextStyle(color: Colors.purple),

                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 500,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: Colors.purple),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                              15.0),
                          //                 <--- border radius here
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "E-mail",hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.purple,
                          style: TextStyle(color: Colors.purple),

                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 500,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: Colors.purple),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                              15.0),
                          //                 <--- border radius here
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Password",hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.purple,
                          style: TextStyle(color: Colors.purple),
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,

                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 8),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          child: Text('Sign-Up'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                          onPressed: ()  async {
                            var appleInBytes = utf8.encode(_passwordController.text);
                            String value = sha256.convert(appleInBytes).toString();
                            String value2 = Crypt.sha256(_passwordController.text, salt: 'abcdefghijklmnop').toString();

                            if(await register(_emailController.text, value2)){
                              createUser(FirebaseAuth.instance.currentUser!.uid, _nameController.text, _emailController.text, value2);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  Home()),
                              );

                            }
                            print(FirebaseAuth.instance.currentUser.toString());




                          }
                      ),
                    ) ,
                  )

                ],
              ),
            ],
          ),
      ),
    );
  }
}
